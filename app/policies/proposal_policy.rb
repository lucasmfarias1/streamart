class ProposalPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def show?
    proposal_is_owned_by_user || user.admin?
  end

  def create?
    artist_offers_services
  end

  def destroy?
    proposal_is_owned_by_user && proposal_is_pending
  end

  def submit?
    destroy? && proposal_has_items
  end

  private

  def proposal_is_owned_by_user
    record.customer == user
  end

  def artist_offers_services
    record.artist.services.count > 0
  end

  def proposal_is_pending
    record.status == 1
  end

  def proposal_has_items
    record.proposal_items.count > 0
  end
end
