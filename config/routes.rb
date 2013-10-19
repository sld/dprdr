Dpreader::Application.routes.draw do
  resources :books

  root :to => "home#index"

  devise_for :users
end
