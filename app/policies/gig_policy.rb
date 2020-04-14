class GigPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def create?
    gig_artist_is_user
  end

  private

  def gig_artist_is_user
    record.artist == user
  end
end
