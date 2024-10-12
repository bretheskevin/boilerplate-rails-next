module CrudConcern
  extend ActiveSupport::Concern

  included do
    before_action :set_object, only: %i[update destroy show]
    before_action :check_required_param, only: %i[create update]
  end

  def index
    authorize base_class

    init_pagination

    @objects = objects_paginated

    render json: @objects
  end

  def show
    authorize @object

    render json: @object
  end

  def create
    authorize object_class

    @object = object_class.new
    process_object
  end

  def update
    authorize @object

    process_object
  end

  def destroy
    authorize @object

    @object.destroy
    render status: :no_content
  end

  def base_class
    controller_name.classify.constantize
  rescue
    "not-found"
  end

  def object_class
    raise NotImplementedError
  end

  def use_slug?
    false
  end

  private

  def model_param
    return base_class if base_class == "not-found"

    base_class&.model_name&.singular
  end

  def strong_params
    params.require(model_param).permit(base_class.strong_params)
  end

  def set_object
    @object = object_class
    @object = object_class.with_deleted if object_class.respond_to?(:with_deleted)

    @object = @object.find_by(id: params[:id])
    @object = @object.find_by(slug: params[:slug]) if use_slug?

    return unless @object.nil?

    render json: ApiErrorResponse.not_found(base_class.model_name.human), status: :not_found
  end

  def process_object
    @object.assign_attributes(strong_params.to_hash)

    if @object.valid?
      @object.save!
      render json: @object
    else
      render_error_response
    end
  end

  def render_error_response
    render json: ApiErrorResponse.new("Params are not valid", @object.errors.full_messages), status: :unprocessable_content
  end

  def total_objects
    objects_query.count
  end

  def objects_query
    object = object_class

    object = ObjectQueryService.apply(object, params)

    object.order(base_class.default_sort)
  end

  def check_required_param
    if model_param == "not-found"
      render json: ApiErrorResponse.not_found("Route"), status: :not_found
      return
    end

    return if params[model_param].present?

    render json: ApiErrorResponse.new(I18n.t("errors.messages.missing_params"), [model_param]), status: :unprocessable_content
    false
  end

  def init_pagination
    @per_page = params[:per_page].present? ? params[:per_page].to_i : 20
    @page = params[:page].present? ? params[:page].to_i : 1
    @total_pages = (total_objects / @per_page.to_f).ceil
  end

  def objects_paginated
    models = objects_query.page(@page).per(@per_page)

    {
      models: models,
      current_page: @page,
      total_pages: @total_pages,
      per_page: @per_page,
      total_objects: total_objects
    }
  end
end
