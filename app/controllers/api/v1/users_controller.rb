class Api::V1::UsersController < ApplicationController
  acts_as_token_authentication_handler_for User, except: [:create]
  before_action :fetch_user, only: [:update]

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

  def fetch_user
    @user = User.find(params[:id])

    head :unauthorized unless current_user == @user || current_user.is_admin?
  end
end