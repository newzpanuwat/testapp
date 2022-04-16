Rails.application.routes.draw do
  devise_for :users, defaults: { format: :json },
            controllers: {
                sessions: 'users/sessions',
                registrations: 'users/registrations'
            }

  namespace :api do
    namespace :v1 do
      resources :categories do
      resources :products
      end
      get '/products', to: "products#all"
    end
  end
end
