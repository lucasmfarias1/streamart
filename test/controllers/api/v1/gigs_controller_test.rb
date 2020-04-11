# require 'test_helper'

# class Api::V1::GigsControllerTest < ActionDispatch::IntegrationTest
#   setup do
#     @artist = users(:artist)
#     @customer = users(:customer)

#     @headers = {
#       'X-User-Email': @customer.email,
#       'X-User-Token': @customer.authentication_token
#     }
#   end

#   test 'creates a gig' do
#     gig_params = {
#       artist_id: @artist.id,
#       gig_items_attributes: [
#         {
#           title: 'Emote',
#           description: 'Your regular Twitch.tv emote',
#           price: 4.99
#         },
#         {
#           title: 'Emote',
#           description: 'Another regular Twitch.tv emote',
#           price: 4.99
#         },
#         {
#           title: 'Avatar',
#           description: 'Your regular Twitch.tv avatar',
#           price: 9.99
#         },
#       ]
#     }

#     post(
#       api_v1_gigs_path,
#       headers: @headers,
#       params: { gig: gig_params }
#     )
#     gig = Gig.first

#     assert_response :success
#     assert Gig.count == 1
#     assert GigItem.count == 3
#     assert @artist.gigs_as_artist.count == 1
#     assert @customer.gigs_as_customer.count == 1
#     assert gig.status == 1
#     assert gig.customer == @customer
#     assert gig.artist == @artist
#   end
# end