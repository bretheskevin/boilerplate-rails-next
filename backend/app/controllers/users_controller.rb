class UsersController < ApplicationController
  def base_class
    ::User
  end

  def object_class
    base_class
  end
end
