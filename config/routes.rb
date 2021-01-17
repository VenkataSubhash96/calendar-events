Rails.application.routes.draw do
  resources :events, only: [:index]
  resources :users, only: [] do
    collection do
      get :availability
    end
  end
end
