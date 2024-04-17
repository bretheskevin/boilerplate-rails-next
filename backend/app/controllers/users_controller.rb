class UsersController < ApplicationController
  def index
    @users = User.all
    render json: @users
  end

  def show
    @user = User.find_by(id: params[:id])

    if @user.nil?
      render json: { error: "User not found", error_description: [] }, status: 404
      return
    end

    render json: @user
  end
end
