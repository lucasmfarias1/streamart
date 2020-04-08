class Api::V1::ProposalItemsController < ApplicationController
  def create
    proposal = Proposal.find(params[:proposal_id])
    service = proposal
      .artist
      .services
      .where(id: proposal_item_params[:service_id])
      .first

    proposal_item = ProposalItem.new({
      proposal_id: proposal.id,
      service_id: service.id
    })

    if proposal_item.save
      head :ok
    else
      head :unprocessable_entity
    end
  end

  private

  def proposal_item_params
    params.permit(:service_id)
  end
end