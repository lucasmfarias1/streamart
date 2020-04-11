class Api::V1::SessionsController < ApplicationController
  acts_as_token_authentication_handler_for User, except: [:create]
  after_action :verify_authorized, except: [:create]

  def create
    @user = User.find_by email: params[:email]

    if @user&.valid_password? params[:password]
      render :create
    else
      head :unauthorized
    end
  end

  def destroy
    user = authorize(User.find(params[:id]), :update?)
    user.authentication_token = nil

    if user.save
      head :ok
    else
      head :unauthorized
    end
  end
end