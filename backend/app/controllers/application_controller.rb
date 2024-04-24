class ApplicationController < ActionController::API
  include CrudConcern
  include DeviseConcern
  include Pundit::Authorization

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def not_found
    render json: { error: "Not Found", error_description: [] }, status: :not_found
  end

  def user_not_authorized(_exception)
    render json: { error: "Unauthorized", error_description: [] }, status: :unauthorized
  end

  def pundit_user
    current_devise_api_user
  end
end
