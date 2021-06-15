Rails.application.routes.draw do
  root to: 'main#index'

  get 'signup', to: 'users#new'
  post 'signup', to: 'users#create'
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  get 'logout', to: 'sessions#destroy'

  get 'user', to: 'main#user'

  get '/quickbuy/:drink_id/:stock_change/', to: 'user/transactions#quick_buy'

  resources :transactions, :only => [:index, :show]
  resources :drinks do
  end

  namespace :admin do
    get '/', to: 'main#index'
    resources :transactions
    resources :users
    resources :drinks
  end

  namespace :user do
    resources :transactions, :except => [:destroy, :edit, :update]
    get 'transactions/new/:drink_id', to: 'transactions#new'
  end
end
