class GigPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def show?
    gig_artist_is_user || gig_customer_is_user || user.admin?
  end

  def create?
    gig_artist_is_user
  end

  def finish?
    (gig_artist_is_user || gig_customer_is_user) && record.ongoing?
  end

  private

  def gig_artist_is_user
    record.artist == user
  end

  def gig_customer_is_user
    record.customer == user
  end
end
