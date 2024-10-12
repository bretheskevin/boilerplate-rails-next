class ApplicationController < ActionController::API
  include CrudConcern
  include DeviseConcern
  include Pundit::Authorization

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def user_not_authorized(_exception)
    render json: ApiErrorResponse.new("Unauthorized"), status: :unauthorized
  end

  def pundit_user
    current_devise_api_user
  end

  def not_found
    render json: ApiErrorResponse.not_found, status: :not_found
  end
end
