require 'test_helper'

module Api
  module V1
    class SessionsControllerTest < ActionDispatch::IntegrationTest
      test 'logs in user' do
        user_params = {
          email: Faker::Internet.email,
          password: Faker::Internet.password
        }
        user = User.create(user_params)

        post(
          api_v1_sessions_path,
          params: user_params
        )

        response = JSON.parse(@response.body)['data']['user']
        user = User.find_by email: response['email']

        assert_response :success
        assert response['email'] == user_params[:email]
        assert response['authentication_token'] == user.authentication_token
      end

      test 'logs out user' do
        user = users(:one)
        headers = {
          'X-User-Email': user.email,
          'X-User-Token': user.authentication_token
        }
        old_token = user.authentication_token

        delete(
          api_v1_session_path(user),
          headers: headers
        )

        new_token = user.reload.authentication_token

        assert_response :success
        assert new_token != old_token
      end
    end
  end
end