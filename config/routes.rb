Rails.application.routes.draw do
  devise_for :users

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :sessions, only: [:create, :destroy]
      resources :users, only: [:create, :update]
      resources :proposals, only: [:create] do
        resources(
          :proposal_items,
          only: [:create, :update, :destroy, :show],
          shallow: true
        )
      end
      resources :gigs, only: [:create]
    end
  end
end
