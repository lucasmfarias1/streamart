require 'test_helper'

class Api::V1::ProposalsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @artist = users(:artist)
    @customer = users(:customer)
    @service = @artist.services.create(
      title: 'Art',
      description: 'Generic art about anything',
      price: 9.99
    )

    @headers = {
      'X-User-Email': @customer.email,
      'X-User-Token': @customer.authentication_token
    }
  end

  test 'creates a proposal' do
    proposal_params = { artist_id: @artist.id }

    assert_difference([
      'Proposal.count',
      '@artist.proposals_as_artist.count',
      '@customer.proposals_as_customer.count'
    ], 1) do
      post(
        api_v1_proposals_path,
        headers: @headers,
        params: proposal_params
      )
    end

    proposal = @customer.proposals_as_customer.last

    assert_response :success
    assert proposal.status == 1
    assert proposal.customer == @customer
    assert proposal.artist == @artist
  end

  test 'shows a proposal' do
    proposal = Proposal.create(
      artist: @artist,
      customer: @customer,
      status: 1
    )
    proposal.proposal_items.create(service: @service)

    get(
      api_v1_proposal_path(proposal),
      headers: @headers
    )

    response = JSON.parse(@response.body)['data']['proposal']

    assert response['id'] == proposal.id
    assert response['customer_id'] == proposal.customer_id
    assert response['artist_id'] == proposal.artist_id
    assert response['proposal_items'].count == 1
  end

  test 'destroys a proposal' do
    proposal = Proposal.create(
      artist: @artist,
      customer: @customer,
      status: 1
    )
    proposal.proposal_items.create(service: @service)

    assert_difference(['Proposal.count', 'ProposalItem.count'], -1) do
      delete(
        api_v1_proposal_path(proposal),
        headers: @headers
      )
    end
  end

  test 'submits a proposal' do
    proposal = Proposal.create(
      artist: @artist,
      customer: @customer,
      status: 1
    )
    proposal.proposal_items.create(service: @service)

    assert_difference 'proposal.reload.status', 1 do
      post(
        submit_api_v1_proposal_path(proposal),
        headers: @headers
      )
    end
  end
end