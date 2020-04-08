require 'test_helper'

class Api::V1::ProposalsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @artist = users(:artist)
    @customer = users(:customer)

    @headers = {
      'X-User-Email': @customer.email,
      'X-User-Token': @customer.authentication_token
    }
  end

  test 'creates a proposal' do
    proposal_params = {
      artist_id: @artist.id
    }

    assert_difference([
      'Proposal.count',
      '@artist.proposals_as_artist.count',
      '@customer.proposals_as_customer.count'
    ], 1) do
      post(
        api_v1_proposals_path,
        headers: @headers,
        params: { proposal: proposal_params }
      )
    end

    proposal = Proposal.last

    assert_response :success
    assert proposal.status == 1
    assert proposal.customer == @customer
    assert proposal.artist == @artist
  end
end