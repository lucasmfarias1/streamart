class Api::V1::ProposalsController < ApplicationController
  def create
    @proposal = Proposal.new(proposal_params)
    @proposal.customer = current_user
    @proposal.status = 1

    if @proposal.save
      head :ok
    else
      head :unprocessable_entity
    end
  end

  private

  def proposal_params
    params.require(:proposal).permit(:artist_id)
  end
end