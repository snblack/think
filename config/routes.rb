Rails.application.routes.draw do
  devise_for :users
  root to: "questions#index"

  resources :questions do
    resources :answers, shallow: true do
      get '', to: 'answers#best', as: :best
    end
  end

end
