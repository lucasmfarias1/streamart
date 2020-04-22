require 'test_helper'

class Api::V1::FeedbacksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @artist = users(:artist)
    @customer = users(:customer)
    @proposal = @customer.proposals_as_customer.create(
      artist: @artist,
      status: 1
    )
    @gig = Gig.create(
      artist: @proposal.artist,
      customer: @proposal.customer,
      status: 1
    )
    @headers = {
      'X-User-Email': @customer.email,
      'X-User-Token': @customer.authentication_token
    }
  end

  test 'creates feedback' do
    feedback_params = {
      body: "I liked working with this person",
      gig_id: @gig.id
    }

    assert_difference([
      'Feedback.count',
      '@customer.reload.feedbacks_given.count',
      '@artist.reload.feedbacks_taken.count',
    ], 1) do
      post(
        api_v1_feedbacks_path,
        headers: @headers,
        params: feedback_params
      )
      p @response.status
    end

  end
end