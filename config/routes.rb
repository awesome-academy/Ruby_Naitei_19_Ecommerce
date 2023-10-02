Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    resources :products
    resources :users
    get '/cart', to: 'products#cart'
    get '/login', to: 'users#login'
    get '/signup', to: 'users#new'
    get '/filter', to: 'products#filter'
    post '/search', to: 'products#search'
    get '/search', to: "products#render_search_page"
    post '/cart', to: "products#add_to_cart"
  end
end
