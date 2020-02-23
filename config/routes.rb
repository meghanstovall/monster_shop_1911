Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get '/', to: 'welcome#index'
  get "/merchants", to: "merchants#index"
  get "/merchants/new", to: "merchants#new"
  get "/merchants/:id", to: "merchants#show"
  post "/merchants", to: "merchants#create"
  get "/merchants/:id/edit", to: "merchants#edit"
  patch "/merchants/:id", to: "merchants#update"
  delete "/merchants/:id", to: "merchants#destroy"

  get "/items", to: "items#index"
  get "/items/:id", to: "items#show"
  get "/items/:id/edit", to: "items#edit"
  patch "/items/:id", to: "items#update"
  get "/merchants/:merchant_id/items", to: "items#index"
  get "/merchants/:merchant_id/items/new", to: "items#new"
  post "/merchants/:merchant_id/items", to: "items#create"
  delete "/items/:id", to: "items#destroy"

  get "/items/:item_id/reviews/new", to: "reviews#new"
  post "/items/:item_id/reviews", to: "reviews#create"

  get "/reviews/:id/edit", to: "reviews#edit"
  patch "/reviews/:id", to: "reviews#update"
  delete "/reviews/:id", to: "reviews#destroy"

  post "/cart/:item_id", to: "cart#add_item"
  get "/cart", to: "cart#show"
  delete "/cart", to: "cart#empty"
  delete "/cart/:item_id", to: "cart#remove_item"
  patch "/cart/:item_id/:quantity", to: "cart#edit_quantity"


  get "/orders/new", to: "orders#new"
  post "/orders", to: "orders#create"
  get "/orders/:id", to: "orders#show"
  patch "/orders/:id", to: "orders#update"

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
  #only admin users will be able to reach this resource
  get '/dashboard', to: "dashboard#show"
  get '/:merchant_id/dashboard', to: "dashboard#show"
  get '/:merchant_id/items', to: "items#index"
end

  namespace :admin do
  #only admin users will be able to reach this resource
    get '/dashboard', to: "dashboard#show"
    get '/profile/:id', to: "users#show"
    patch '/orders/:id', to: "dashboard#update"
    # get '/merchant/:merchant_id', to: "dashboard#show"
  end
end
