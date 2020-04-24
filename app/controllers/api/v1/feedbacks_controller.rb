class Api::V1::FeedbacksController < ApplicationController
  before_action :set_feedback, only: [:show, :destroy, :update]

  def show
    render :show, status: :ok
  end
  
  def create
    feedback = Feedback.new(feedback_params)
    feedback.giver = current_user
    feedback.taker = feedback.gig.the_other_user(current_user)
    authorize feedback

    if feedback.save
      head :ok
    else
      p feedback.errors
      head :unprocessable_entity
    end
  end

  def update
    if @feedback.update(hidden: params[:hidden])
      head :ok
    else
      head :unprocessable_entity
    end
  end

  def destroy
    if @feedback.destroy
      head :ok
    else
      head :unprocessable_entity
    end
  end

  private

  def feedback_params
    params.permit(:body, :gig_id)
  end

  def set_feedback
    @feedback = authorize Feedback.find(params[:id])
  end
end