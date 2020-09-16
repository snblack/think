Rails.application.routes.draw do
  devise_for :users
  root to: "questions#index"

  resources :questions do
    resources :answers, shallow: true do
      get '', to: 'answers#mark_as_best', as: :best
    end
  end

end
