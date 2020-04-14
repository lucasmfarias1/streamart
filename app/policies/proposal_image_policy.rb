class ProposalImagePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def create?
    proposal_customer_is_user? && proposal_is_pending?
  end

  def destroy?
    create? || user.admin?
  end

  private

  def proposal_customer_is_user?
    record.proposal_item.proposal.customer == user
  end

  def proposal_is_pending?
    record.proposal_item.proposal.status == 1
  end
end
