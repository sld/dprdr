Dpreader::Application.routes.draw do
  resources :books do
    collection do
      get 'try_as_guest'
      get 'viewer'
    end
  end

  root :to => "home#index"

  devise_for :users
end
