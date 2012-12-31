TaokeSimple::Application.routes.draw do
  resources :words

  constraints :subdomain => /[a-z]{4}/ do
    match '/flush'=>'words#flush'
    root :to => 'words#home'
  end
  authenticated :user do
    root :to => 'home#index'
  end
  root :to => "home#index"
  devise_for :users
  resources :users
  resque_constraint = lambda do |request|
    Rails.env.development? or 
      (request.env['warden'].authenticate? and request.env['warden'].user.has_role?(:admin))
  end
  constraints resque_constraint do
    mount Resque::Server.new, :at => "/resque"
  end
end
