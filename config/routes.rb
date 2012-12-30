TaokeSimple::Application.routes.draw do
  resources :words

  constraints :subdomain => /[a-z]{4}/ do
    root :to => 'words#home'
  end
  authenticated :user do
    root :to => 'home#index'
  end
  root :to => "home#index"
  devise_for :users
  resources :users
end
