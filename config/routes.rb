Rails.application.routes.draw do
  devise_for :users

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :feedbacks, only: [:create, :show, :destroy, :update]
      resources :sessions, only: [:create, :destroy]
      resources :users, only: [:create, :update]
      resources :gigs, only: [:create, :show] do
        post :finish, on: :member
      end
      resources :proposals, only: [:create, :show, :destroy] do
        post :submit, on: :member
        post :reject, on: :member

        resources(
          :proposal_items,
          only: [:create, :update, :destroy, :show],
          shallow: true
        )
      end
      resources :proposal_images, only: [:create, :destroy, :show]
    end
  end
end
