require 'test_helper'

module Api
  module V1
    class UsersControllerTest < ActionDispatch::IntegrationTest
      test 'creates user' do
        user_params = {
          email: Faker::Internet.email,
          password: Faker::Internet.password
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
    end
  end
end