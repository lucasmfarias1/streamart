class ProposalPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def show?
    user_is_proposal_customer ||
    user.admin? ||
    (user_is_proposal_artist && record.submitted?)
  end

  def create?
    artist_offers_services
  end

  def destroy?
    user_is_proposal_customer && record.pending?
  end

  def submit?
    destroy? && proposal_has_items
  end

  def reject?
    (user_is_proposal_artist || user_is_proposal_customer) && record.submitted?
  end

  private

  def user_is_proposal_customer
    user == record.customer
  end

  def user_is_proposal_artist
    user == record.artist
  end

  def artist_offers_services
    record.artist.services.count > 0
  end

  def proposal_has_items
    record.proposal_items.count > 0
  end
end
