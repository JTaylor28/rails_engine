Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get "/merchants/find", to: "merchants/search#show"
      get "/items/find_all", to: "items/search#index"

      resources :merchants, only: [:index, :show] do
        get "/items", to: "merchants/items#index"
      end

      resources :items do 
        get "/merchant", to: "items/merchants#show"
      end
    end
  end
end
