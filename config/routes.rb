Rails.application.routes.draw do
  devise_for :users

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :sessions, only: [:create, :destroy]
      resources :users, only: [:create, :update]
      resources :gigs, only: [:create]
      resources :proposals, only: [:create, :show, :destroy] do
        post :submit, on: :member

        resources(
          :proposal_items,
          only: [:create, :update, :destroy, :show],
          shallow: true
        )
      end
      resources :proposal_images, only: [:create, :destroy]
    end
  end
end
