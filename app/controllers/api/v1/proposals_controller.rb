class Api::V1::ProposalsController < ApplicationController
  after_action :verify_authorized, except: :create

  def create
    proposal = current_user.proposals_as_customer.build(proposal_params)
    proposal.status = 1

    if proposal.save
      head :ok
    else
      head :unprocessable_entity
    end
  end

  private

  def proposal_params
    params.permit(:artist_id)
  end
end