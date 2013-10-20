Dpreader::Application.routes.draw do

  root :to => "home#index"

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  resources :books do
    collection do
      get 'try_as_guest'
    end
    member do
      get 'viewer'
    end
  end


  # Api section
  namespace :api do
    namespace :v1 do
      post 'books/:id/save_page', :to => 'books#save_page'
    end
  end
end
