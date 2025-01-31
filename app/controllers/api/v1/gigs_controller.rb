class Api::V1::GigsController < ApplicationController
  before_action :set_gig, only: [:show, :finish]
  
  def create
    proposal = current_user
      .proposals_as_artist
      .where(status: 2)
      .find(params[:proposal_id])
    gig = authorize Gig.new(
      artist: proposal.artist,
      customer: proposal.customer,
      status: 1
    )

    begin
      ActiveRecord::Base.transaction do
        gig.save
        proposal.update(status: 3)
        proposal.proposal_items.each do |proposal_item|
          gig.gig_items.create(
            title: proposal_item.title,
            description: proposal_item.description,
            price: proposal_item.service.price,
            title_service: proposal_item.service.title,
            description_service: proposal_item.service.description
          )
        end
      end

      head :ok
    rescue
      head :unprocessable_entity
    end
  end

  def show
    render :show, status: :ok
  end

  def finish
    @gig.status = 2

    if @gig.save
      head :ok
    else
      head :unprocessable_entity
    end
  end

  private

  def gig_params
    params.permit(:proposal_id)
  end

  def set_gig
    @gig = authorize Gig.find(params[:id])
  end
end