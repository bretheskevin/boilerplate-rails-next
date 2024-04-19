module CrudConcern
  extend ActiveSupport::Concern

  included do
    before_action :set_object, only: %i[edit update destroy show undelete]
  end

  def index
    # authorize base_class

    @objects = object_class.all
    render json: @objects
  end

  def show
    render json: { error: "#{base_class.model_name.human} not found", error_description: [] }, status: 404 if @object.nil?

    # authorize @object

    render json: @object
  end

  def new
    # authorize object_class

    @object = object_class.new
  end

  def create
    authorize object_class

    @object = object_class.new

    if @object.valid?
      @object.save!
      render json: @object
    else
      render json: { error: "Params are not valid", error_description: @object.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def edit
    authorize @object

    render "new"
  end

  def update
    authorize @object

    @object.assign_attributes()

    if @object.valid?
      @object.save!
      render json: @object
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    # authorize @object

    @object.destroy
    render status: :no_content
  end

  def total_objects
    objects_query.count.to_f
  end

  def objects_query
    object_class.all.order(base_class.default_sort)
  end

  def base_class
    raise NotImplementedError
  end

  def object_class
    raise NotImplementedError
  end

  def use_slug?
    true
  end

  private

  def set_object
    return @object = object_class.find_by(slug: params[:slug]) if use_slug?

    @object = object_class.find params[:id]
  end
end