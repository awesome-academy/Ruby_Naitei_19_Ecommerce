Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    resources :products
    resources :users
    get '/cart', to: 'products#cart'
    get '/login', to: 'users#login'
    get '/signup', to: 'users#new'
  end
end
