class FeedbackPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def show?
    user_is_related_to_gig || user.admin?
  end

  def create?
    user_is_related_to_gig &&
    user_is_giver &&
    user_has_not_already_left_feedback
  end

  def update?
    user_is_taker || user.admin?
  end

  def destroy?
    user.admin?
  end

  private

  def user_is_related_to_gig
    record.gig.customer == user ||
    record.gig.artist == user
  end

  def user_is_giver
    record.giver == user
  end

  def user_is_taker
    record.taker == user
  end

  def user_has_not_already_left_feedback
    Feedback.where(
      gig_id: record.gig.id,
      giver_id: user.id
    ).count < 1
  end
end
