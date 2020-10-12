Rails.application.routes.draw do
  devise_for :users
  root to: "questions#index"

  concern :votable do
    member do
      put 'up'
      put 'down'
    end
  end

  resources :files, only: [:destroy]
  resources :links, only: [:destroy]
  resources :rewards, only: [:index]

  resources :questions do
    resources :answers, shallow: true do
      concerns :votable
      member do
        put 'mark_as_best'
      end
    end
    concerns :votable
  end



end
