class Api::V1::ProposalItemsController < ApplicationController
  before_action :fetch_proposal_item, only: [:update, :destroy, :show]

  def show
    render :show, status: :ok
  end
  
  def create
    proposal = Proposal.find(params[:proposal_id])
    service = proposal
      .artist
      .services
      .where(id: params[:service_id])
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

  def update
    if @proposal_item.update(proposal_item_params)
      head :ok
    else
      head :unprocessable_entity
    end
  end

  def destroy

    if @proposal_item.destroy
      head :ok
    else
      head :unprocessable_entity
    end
  end

  private

  def proposal_item_params
    params.permit(:title, :description)
  end

  def fetch_proposal_item
    @proposal_item = current_user
      .proposal_items_as_customer
      .where(id: params[:id])
      .first
  end
end