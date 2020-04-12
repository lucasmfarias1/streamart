class ProposalItemPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def show?
    proposal_is_owned_by_user || user.admin?
  end

  def create?
    proposal_is_owned_by_user &&
    service_is_offered_by_artist &&
    proposal_is_pending
  end

  def update?
    proposal_is_owned_by_user && proposal_is_pending
  end

  def destroy?
    update?
  end

  private

  def proposal_is_owned_by_user
    record.proposal.customer == user
  end

  def service_is_offered_by_artist
    record.service.user == record.proposal.artist
  end

  def proposal_is_pending
    record.proposal.status == 1
  end
end
