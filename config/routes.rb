TaokeSimple::Application.routes.draw do
  get "shops/recent",:as=>'recent_shops'
  get "shops/top",:as=>'hot_shops'
  #match "shop/:id" => 'shop#show',:as=>'shop'

  match '/img/:p1/:p2(/:p3)/(*all)' => redirect("http://img%{p1}.taobaocdn.com/bao/uploaded/i%{p2}/%{all}.jpg")
  match '/shoplogo/(*all)' => redirect("http://logo.taobaocdn.com/shop-logo/%{all}")
  get "items/recent",:as=>'items_recent'
  get "items/hot",:as=>'items_hot'
  match "item/:id" => 'items#show',:as=>'item'
  match "/status" => 'home#status',:as=>'status'

  match '/outlink/item/:id'=>'items#link',:as=>'item_link'
  match '/outlink/shop/:id'=>'shops#link',:as=>'shop_link'

  resources :words

  devise_for :users
  resources :users
  resque_constraint = lambda do |request|
    Rails.env.development? or 
      (request.env['warden'].authenticate? and request.env['warden'].user.has_role?(:admin))
  end
  constraints resque_constraint do
    mount Resque::Server.new, :at => "/resque"
  end
  constraints :subdomain => 'shop' do
    match ':id' => 'shops#show',:as=>'shop_home'
    root :to => redirect(:subdomain=>Settings.primary_domain)
  end
  if Settings.use_subdomain 
    constraints :subdomain => /[a-z]{4}/ do
      match '/flush'=>'words#flush'
      root :to => 'words#home'
    end
  else
    match ':id' => 'words#home',:as=>'word_home',:constraints=>{:id=>/[a-z]{4,5}/}
  end
  authenticated :user do
    root :to => 'home#index'
  end
  root :to => "home#index"
end
