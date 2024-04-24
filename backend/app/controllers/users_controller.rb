class UsersController < ApplicationController
  before_action :authenticate_devise_api_token!

  def object_class
    base_class
  end
end
