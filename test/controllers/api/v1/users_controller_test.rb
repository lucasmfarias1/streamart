require 'test_helper'

module Api
  module V1
    class UsersControllerTest < ActionDispatch::IntegrationTest
      test 'creates user' do
        user_params = {
          email: Faker::Internet.email,
          password: Faker::Internet.password,
          avatar: fixture_file_upload('images/axe.jpg', 'image/jpg')
        }

        post(
          api_v1_users_path,
          headers: @header,
          params: { user: user_params }
        )

        response = JSON.parse(@response.body)['data']['user']
        user = User.find_by email: response['email']

        assert_response :success
        assert response['email'] == user_params[:email]
        assert response['authentication_token'] == user.authentication_token
      end

      test 'updates user' do
        user = users(:one)
        old_service_count = user.services.count
        headers = {
          'X-User-Email': user.email,
          'X-User-Token': user.authentication_token
        }
        user_params = {
          password: Faker::Internet.password,
          avatar: fixture_file_upload('images/axe.jpg', 'image/jpg'),
          services_attributes: [
            {
              title: 'Emote',
              description: 'Your average Twitch emote',
              price: 4.99
            },
            {
              title: 'Overlay',
              description: 'Your average Twitch overlay',
              price: 14.99
            },
          ]
        }

        patch(
          api_v1_user_path(user),
          headers: headers,
          params: { user: user_params }
        )

        new_service_count = user.reload.services.count

        assert_response :success
        assert new_service_count == old_service_count + 2
        assert user.valid_password?(user_params[:password])
      end
    end
  end
end
