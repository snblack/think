Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: "oauth_callbacks" }
  root to: "questions#index"

  concern :votable do
    member do
      put 'up'
      put 'down'
    end
  end
  concern :commentable do
    resources :comments, only: :create
  end

  resources :files, only: [:destroy]
  resources :links, only: [:destroy]
  resources :rewards, only: [:index]

  resources :questions do
    resources :answers, shallow: true do
      concerns [:commentable, :votable]
      member do
        put 'mark_as_best'
      end
    end
    concerns [:commentable, :votable]
  end

  mount ActionCable.server => '/cable'

  namespace :api do
    namespace :v1 do
      resources :profiles, only: [] do
        get :me, on: :collection
        get :index, on: :collection
      end

      resources :questions, only: [:index, :show, :create, :update, :destroy] do
        resources :answers, only: [:index, :show, :create, :update, :destroy], shallow: true
      end

    end
  end

end
