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
    return true if admin?

    @user.id == @record.id
  end
end
