require 'test_helper'

class Api::V1::GigsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @artist = users(:artist)
    @customer = users(:customer)
    @service = @artist.services.create(
      title: 'Art',
      description: 'Generic art about anything',
      price: 9.99
    )
    @proposal = @customer.proposals_as_customer.create(
      artist: @artist,
      status: 1
    )
    @proposal_item = @proposal.proposal_items.create(
      service: @service,
      title: 'Happy face emote',
      description: 'An emote of a happy face'
    )

    @headers = {
      'X-User-Email': @artist.email,
      'X-User-Token': @artist.authentication_token
    }
  end

  test 'creates a gig' do
    # proposal status 2 means SUBMITTED
    @proposal.update(status: 2)

    gig_params = { proposal_id: @proposal.id }

    assert_difference(['Gig.count', '@proposal.reload.status'], 1) do
      post(
        api_v1_gigs_path,
        headers: @headers,
        params: gig_params
      )
    end

    gig = @artist.gigs_as_artist.last

    assert @proposal.proposal_items.count == gig.gig_items.count
    assert gig.ongoing?
  end

  test 'shows a gig' do
    gig = Gig.create(
      artist: @proposal.artist,
      customer: @proposal.customer,
      status: 1
    )
    @proposal.proposal_items.each do |proposal_item|
      gig.gig_items.create(
        title: proposal_item.title,
        description: proposal_item.description,
        price: proposal_item.service.price,
        title_service: proposal_item.service.title,
        description_service: proposal_item.service.description
      )
    end

    get(
      api_v1_gig_path(gig),
      headers: @headers
    )

    result = JSON.parse(@response.body)['data']['gig']
    gig_returned = Gig.find(result['id'])

    assert_response :success
    assert gig == gig_returned
    assert gig.gig_items.count == result['gig_items'].count
  end

  test 'finishes a gig' do
    gig = Gig.create(
      artist: @proposal.artist,
      customer: @proposal.customer,
      status: 1
    )
    @proposal.proposal_items.each do |proposal_item|
      gig.gig_items.create(
        title: proposal_item.title,
        description: proposal_item.description,
        price: proposal_item.service.price,
        title_service: proposal_item.service.title,
        description_service: proposal_item.service.description
      )
    end

    assert_difference 'gig.reload.status', 1 do
      post(
        finish_api_v1_gig_path(gig),
        headers: @headers
      )
    end
    assert gig.finished?
  end
end
