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

    if @object.nil?
      render json: { error: "#{base_class.model_name.human} not found", error_description: [] }, status: :not_found
      return
    end

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
    raise NotImplementedError
  end

  def object_class
    raise NotImplementedError
  end

  def use_slug?
    false
  end

  private

  def model_param
    base_class.model_name.singular
  end

  def strong_params
    params.require(model_param).permit(base_class.strong_params)
  end

  def set_object
    @object = object_class.find_by(id: params[:id])
    @object = object_class.find_by(slug: params[:slug]) if use_slug?

    return unless @object.nil?

    render json: { error: "#{base_class.model_name.human} not found", error_description: [] }, status: :not_found
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
    render json: { error: "Params are not valid", error_description: @object.errors.full_messages }, status: :unprocessable_entity
  end

  def total_objects
    objects_query.count
  end

  def objects_query
    object_class.order(base_class.default_sort)
  end

  def check_required_param
    return if params[model_param].present?

    render json: { error: I18n.t("errors.messages.missing_params"), error_description: [model_param] }, status: :unprocessable_entity
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
