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

    @artist_headers = {
      'X-User-Email': @artist.email,
      'X-User-Token': @artist.authentication_token
    }
  end

  test 'creates feedback' do
    feedback_params = {
      body: 'I liked working with this person',
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
    end
  end

  test 'shows feedback' do
    feedback = Feedback.create(
      body: 'I liked working with this person',
      gig_id: @gig.id,
      giver_id: @customer.id,
      taker_id: @artist.id,
      hidden: false
    )

    get(
      api_v1_feedback_path(feedback),
      headers: @headers
    )

    response = JSON.parse(@response.body)['data']['feedback']

    assert_response :success
    assert feedback == Feedback.find(response['id'])
  end

  test 'destroys feedback' do
    feedback = Feedback.create(
      body: 'I liked working with this person',
      gig_id: @gig.id,
      giver_id: @customer.id,
      taker_id: @artist.id,
      hidden: false
    )

    assert_difference 'Feedback.count', -1 do
      delete(
        api_v1_feedback_path(feedback),
        headers: @headers
      )
    end
  end

  test 'hides feedback' do
    feedback = Feedback.create(
      body: 'I liked working with this person',
      gig_id: @gig.id,
      giver_id: @customer.id,
      taker_id: @artist.id,
      hidden: false
    )

    feedback_params = { hidden: true }

    patch(
      api_v1_feedback_path(feedback),
      params: feedback_params,
      headers: @artist_headers
    )

    assert feedback.reload.hidden
  end
end