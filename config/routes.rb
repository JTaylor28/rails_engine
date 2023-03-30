Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :merchants, only: [:index, :show] do
        get "/items", to: "merchant/items#index"
      end

      resources :items do 
        get "/merchant", to: "item/merchants#show"
      end
    end
  end
end
