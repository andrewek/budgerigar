Rails.application.routes.draw do
  root to: 'categories#index'

  resources :categories, only: [:create, :show, :index, :update, :destroy] do
    member do
      post '/allocate', to: 'categories#allocate'
    end
  end

  resources :transactions, only: [:create, :show, :index, :update, :destroy]
end
