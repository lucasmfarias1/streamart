class Api::V1::UsersController < ApplicationController
  acts_as_token_authentication_handler_for User, except: [:create]

  def create
    @user = User.new(user_params)

    if @user.save
      render :create, status: :created
    else
      head(:unprocessable_entity)
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password)
  end
end