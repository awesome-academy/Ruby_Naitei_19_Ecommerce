Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    resources :products
    resources :users
    resource :cart
    get "/signup", to: "users#new"
    get "/filter", to: "products#filter"
    post "/search", to: "products#search"
    get "/search", to: "products#render_search_page"
    post "/login", to: "sessions#create"
    get "/logout", to: "sessions#destroy"
    get "/profile", to: "users#show"
    get "/plus_item", to: "carts#plus"
    get "/minus_item", to: "carts#minus"
    post "/add_to_cart", to: "carts#add_to_cart"
    get "/remove_from_cart", to: "carts#remove_from_cart"
  end
end
