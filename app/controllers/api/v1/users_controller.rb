class Api::V1::UsersController < ApplicationController
  acts_as_token_authentication_handler_for User, except: [:create]
  before_action :set_user, only: [:update]
  after_action :verify_authorized, except: :create

  def create
    @user = User.new(user_signup_params)
    # talvez precise implementar algo assim, resolver depois
    # @user.avatar.attach(params[:avatar])

    if @user.save
      render :create, status: :created
    else
      head :unprocessable_entity
    end
  end
  
  def update
    if @user.update(user_params)
      head :ok
    else
      head :unprocessable_entity
    end
  end

  private

  def user_signup_params
    params.permit(:email, :password, :avatar)
  end

  def user_params
    params.permit(
      :password,
      :avatar,
      services_attributes: [:id, :title, :description, :price]
    )
  end

  def set_user
    @user = authorize User.find(params[:id])
  end
end