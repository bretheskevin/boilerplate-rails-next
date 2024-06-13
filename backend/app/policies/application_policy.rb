# frozen_string_literal: true

class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    true
  end

  def show?
    index?
  end

  def create?
    true
  end

  def update?
    true
  end

  def destroy?
    true
  end

  def admin?
    @user&.role == User.roles[:admin]
  end
end
