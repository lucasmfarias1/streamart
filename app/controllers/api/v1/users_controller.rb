class Api::V1::UsersController < ApplicationController
  acts_as_token_authentication_handler_for User, except: [:create]

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
    @user = current_user
    
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
end