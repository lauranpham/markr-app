Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: "results#index"

  resources :results, defaults: { format: :json }, only: [:index]
  resources :results , defaults: { format: :json } do
    member do
      get :aggregate
    end
  end
  resources :results, only: [:import], path: 'import'
end
