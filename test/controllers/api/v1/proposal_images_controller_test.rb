require 'test_helper'

class Api::V1::ProposalImagesControllerTest < ActionDispatch::IntegrationTest
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
      'X-User-Email': @customer.email,
      'X-User-Token': @customer.authentication_token
    }
  end

  test 'creates a proposal image' do
    proposal_image_params = {
      proposal_item_id: @proposal_item.id,
      image: fixture_file_upload('images/axe.jpg', 'image/jpg')
    }

    assert_difference(['ProposalImage.count'], 1) do
      post(
        api_v1_proposal_images_path,
        headers: @headers,
        params: proposal_image_params
      )
    end

    proposal_image = @proposal_item.proposal_images.last

    assert_response :success
    assert proposal_image.image.attached?
  end

  test 'destroys a proposal image' do
    proposal_image = @proposal_item.proposal_images.create(
      image: fixture_file_upload('images/axe.jpg', 'image/jpg')
    )

    assert_difference(['ProposalImage.count'], -1) do
      delete(
        api_v1_proposal_image_path(proposal_image),
        headers: @headers
      )
    end
  end

  test 'shows a proposal image' do
    proposal_image = @proposal_item.proposal_images.create(
      image: fixture_file_upload('images/axe.jpg', 'image/jpg')
    )

    get(
      api_v1_proposal_image_path(proposal_image),
      headers: @headers
    )

    response = JSON.parse(@response.body)['data']['proposal_image']
    proposal_image_returned = ProposalImage.find(response['id'])

    assert proposal_image == proposal_image_returned
  end
end
