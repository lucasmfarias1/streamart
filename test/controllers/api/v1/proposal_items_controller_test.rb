require 'test_helper'

class Api::V1::ProposalItemsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @artist = users(:artist)
    @service = @artist.services.create({
      title: 'Emote',
      description: 'Twitch Emote',
      price: 4.99
    })
    @customer = users(:customer)
    @proposal = Proposal.create({
      artist: @artist,
      customer: @customer,
      status: 1
    })

    @headers = {
      'X-User-Email': @customer.email,
      'X-User-Token': @customer.authentication_token
    }
  end

  test 'creates a proposal item' do
    proposal_item_params = { service_id: @service.id }

    assert_difference([
      'ProposalItem.count',
      '@proposal.proposal_items.count'
    ], 1) do
      post(
        api_v1_proposal_proposal_items_path(@proposal),
        headers: @headers,
        params: proposal_item_params
      )
    end

    proposal_item = ProposalItem.last

    assert_response :success
    assert proposal_item.service == @service
    assert proposal_item.proposal == @proposal
  end

  test 'updates a proposal item' do
    proposal_item = ProposalItem.create({
      proposal_id: @proposal.id,
      service_id: @service.id
    })
    proposal_item_params = {
      title: 'Happy face emote',
      description: 'An emote that depicts a happy face'
    }

    assert_changes 'proposal_item.reload.updated_at' do
      patch(
        api_v1_proposal_item_path(proposal_item),
        headers: @headers,
        params: proposal_item_params
      )
    end
  end

  test 'deletes a proposal item' do
    proposal_item = ProposalItem.create({
      proposal_id: @proposal.id,
      service_id: @service.id
    })

    assert_difference('ProposalItem.count', -1) do
      delete(
        api_v1_proposal_item_path(proposal_item),
        headers: @headers
      )
    end
  end

  test 'shows a proposal item' do
    proposal_item = ProposalItem.create({
      proposal_id: @proposal.id,
      service_id: @service.id
    })

    get(
      api_v1_proposal_item_path(proposal_item),
      headers: @headers
    )

    response = JSON.parse(@response.body)['data']['proposal_item']

    assert response['id'] == proposal_item.id
    assert response['title'] == proposal_item.title
    assert response['description'] == proposal_item.description
  end
end