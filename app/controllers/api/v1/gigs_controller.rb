class Api::V1::GigsController < ApplicationController
  def create
    @gig = Gig.new(gig_params)
    @gig.customer = current_user
    @gig.status = 1
    
    if @gig.save
      head :ok
    else
      p @gig.errors
      head :unprocessable_entity
    end
  end

  private

  def gig_params
    params.require(:gig).permit(
      :artist_id,
      gig_items_attributes: [:title, :description, :price])
  end
end