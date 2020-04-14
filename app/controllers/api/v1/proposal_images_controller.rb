class Api::V1::ProposalImagesController < ApplicationController
  before_action :set_proposal_image, only: :destroy

  def show
    render :show, status: :ok
  end
  
  def create
    proposal_image = authorize ProposalImage.new(proposal_image_params)

    if proposal_image.save
      head :ok
    else
      head :unprocessable_entity
    end
  end

  def destroy
    if @proposal_image.destroy
      head :ok
    else
      head :unprocessable_entity
    end
  end

  private

  def proposal_image_params
    params.permit(:proposal_item_id, :image)
  end

  def set_proposal_image
    @proposal_image = authorize ProposalImage.find(params[:id])
  end
end