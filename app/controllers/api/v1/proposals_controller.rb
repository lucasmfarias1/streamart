class Api::V1::ProposalsController < ApplicationController
  before_action :set_proposal, only: [:show, :destroy, :submit, :reject]

  def create
    proposal = current_user.proposals_as_customer.build(proposal_params)
    proposal.status = 1
    authorize proposal

    if proposal.save
      head :ok
    else
      head :unprocessable_entity
    end
  end

  def show
    render :show, status: :ok
  end

  def destroy
    if @proposal.destroy
      head :ok
    else
      head :unprocessable_entity
    end
  end

  def submit
    @proposal.status = 2

    if @proposal.save
      head :ok
    else
      head :unprocessable_entity
    end
  end

  def reject
    @proposal.status = 1

    if @proposal.save
      head :ok
    else
      head :unprocessable_entity
    end
  end

  private

  def proposal_params
    params.permit(:artist_id)
  end

  def set_proposal
    @proposal = authorize Proposal.find(params[:id])
  end
end