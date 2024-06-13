class UserPolicy < ApplicationPolicy
  def index?
    admin?
  end

  def show?
    return true if admin?

    @user.id == @record.id
  end

  def update?
    return true if admin?

    @user.id == @record.id
  end

  def destroy?
    return true if @user.id == @record.id
    return false if @record.role == User.roles[:admin]

    admin?
  end
end
