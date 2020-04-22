class Api::V1::FeedbacksController < ApplicationController
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

  private

  def feedback_params
    params.permit(:body, :gig_id)
  end
end