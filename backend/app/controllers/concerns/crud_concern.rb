module CrudConcern
  extend ActiveSupport::Concern

  included do
    before_action :set_object, only: %i[edit update destroy show]
  end

  def index
    # authorize base_class

    @objects = object_class.all
    render json: @objects
  end

  def show
    if @object.nil?
      render json: { error: "#{base_class.model_name.human} not found", error_description: [] }, status: 404
      return
    end

    render json: @object
  end

  def create
    # authorize object_class

    @object = object_class.new
    process_object
  end

  def update
    # authorize @object

    process_object
  end

  def destroy
    # authorize @object

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

  def model_params
    raise NotImplementedError
  end

  private

  def strong_params
    params.require(model_params).permit(base_class.strong_params)
  end

  def set_object
    return @object = object_class.find_by(slug: params[:slug]) if use_slug?

    @object = object_class.find_by(id: params[:id])
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
    objects_query.count.to_f
  end

  def objects_query
    object_class.all.order(base_class.default_sort)
  end
end
