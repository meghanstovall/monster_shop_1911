Rails.application.routes.draw do

  get '/', to: 'welcome#index'

  resources :merchants do
    resources :items, only: [:index, :new, :create]
  end

  resources :items, only: [:index, :show, :edit, :update, :destroy] do
    resources :reviews, only: [:new, :create]
  end

  resources :reviews, only: [:edit, :update, :destroy]

  post "/cart/:item_id", to: "cart#add_item"
  get "/cart", to: "cart#show"
  delete "/cart", to: "cart#empty"
  delete "/cart/:item_id", to: "cart#remove_item"
  patch "/cart/:item_id/:quantity", to: "cart#edit_quantity"

  resources :orders, only: [:new, :create, :show, :update]

  get '/register', to: 'users#new'
  post '/register', to: 'users#create'

  get "/profile", to: 'users#show'
  get "/profile/:profile_id/edit", to: "users#edit"

  get "/profile/:profile_id/edit_password", to: 'users#edit_password'
  patch "/profile/:profile_id", to: 'users#update_password'
  get '/profile/orders/:id', to: 'orders#show'

  patch '/profile', to: 'users#update'
  get '/profile/orders', to: 'orders#index'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/', to: 'sessions#destroy'

  namespace :merchant do
  #only merchant users will be able to reach this resource
    get '/dashboard', to: "dashboard#show"
    get '/:merchant_id/dashboard', to: "dashboard#show"

    get '/discounts', to: "discounts#index"
    get '/discounts/:discount_id', to: "discounts#show"
    get '/discounts/:discount_id/edit', to: "discounts#edit"
    patch '/discounts/:discount_id', to: "discounts#update"
    get '/:merchant_id/discounts/new', to: "discounts#new"
    post '/:merchant_id/discounts', to: "discounts#create"

    get '/:merchant_id/items', to: "items#index"
  end

  namespace :admin do
  #only admin users will be able to reach this resource
    get '/dashboard', to: "dashboard#show"
    get '/merchants', to: "merchants#index"
    get '/profile/:id', to: "users#show"
    patch '/orders/:id', to: "dashboard#update"
    patch '/merchants/:id', to: "merchants#update"
    get '/merchants/:merchant_id', to: "dashboard#show"
    get '/merchants/:merchant_id/orders/:order_id', to: "orders#show"
    get '/merchants/:merchant_id/items', to: "items#index"
    patch '/merchants/:merchant_id/items/:item_id', to: "items#update"
    patch '/merchants/:merchant_id/orders/:order_id/items/:item_id', to: "items#update"
    delete '/merchants/:merchant_id/items/:item_id', to: "items#destroy"
    get '/merchants/:merchant_id/items/new', to: "items#new"
    post '/merchants/:merchant_id/items', to: 'items#create'
    get '/merchants/:merchant_id/items/:item_id/edit', to: 'items#edit'
    get '/users', to: 'admin_users#index'
    get '/users/:user_id', to: 'admin_users#show'
  end
end
