class Api::V1::ProposalItemsController < ApplicationController
  before_action :set_proposal_item, only: [:update, :destroy, :show]

  def show
    render :show, status: :ok
  end
  
  def create
    proposal_item = ProposalItem.new({
      proposal_id: params[:proposal_id],
      service_id: params[:service_id]
    })
    authorize proposal_item

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

  def set_proposal_item
    @proposal_item = authorize ProposalItem.find(params[:id])
  end
end