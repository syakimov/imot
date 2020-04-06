Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'properties#index'
  resources :properties, only: [:index] do
    member do
      post :mark_as_seen
      post :mark_as_starred
    end
  end
end
