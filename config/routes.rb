Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    resources :products
    resources :users
    get "/cart", to: "products#cart"
    get "/signup", to: "users#new"
    get "/filter", to: "products#filter"
    post "/search", to: "products#search"
    get "/search", to: "products#render_search_page"
    post "/login", to: "sessions#create"
    delete "/logout", to: "sessions#destroy"
    get "/profile", to: "users#show"
  end
end
