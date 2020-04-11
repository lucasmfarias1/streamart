class UserPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def update?
    user_is_owner_of_record? || user.admin?
  end

  private

  def user_is_owner_of_record?
    user == record
  end
end
