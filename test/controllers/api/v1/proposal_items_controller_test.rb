require 'test_helper'

class Api::V1::ProposalsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @artist = users(:artist)
    @service = @artist.services.create({
      title: 'Emote',
      description: 'Twitch Emote',
      price: 4.99
    })
    @customer = users(:customer)

    @headers = {
      'X-User-Email': @customer.email,
      'X-User-Token': @customer.authentication_token
    }
  end

  test 'creates a proposal item' do
    proposal = Proposal.create({
      artist: @artist,
      customer: @customer,
      status: 1
    })
    proposal_item_params = { service_id: @service.id }

    assert_difference([
      'ProposalItem.count',
      'proposal.proposal_items.count'
    ], 1) do
      post(
        api_v1_proposal_proposal_items_path(proposal_id: proposal),
        headers: @headers,
        params: proposal_item_params
      )
    end

    proposal_item = ProposalItem.last

    assert_response :success
    assert proposal_item.service == @service
    assert proposal_item.proposal == proposal
  end
end