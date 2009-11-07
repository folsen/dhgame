ActionController::Routing::Routes.draw do |map|
  # The priority is based upon order of creation: first created -> highest priority.
  
  # Sample of regular route:
  # map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  # map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.register '/register', :controller => "sessions", :action => 'create'
  map.login '/login', :controller => 'public', :action => 'index'
  map.signup '/signup', :controller => 'users', :action => 'new'
  
  map.root :controller => "public", :action => "index"
  # TODO refactor these into one method
  map.home "/home", :controller => 'public', :action => 'home'
  map.rules '/rules', :controller => 'public', :action => 'info'
  map.help '/help', :controller => 'public', :action => 'help'
  map.profile '/profile', :controller => 'users', :action => 'edit'
  
  map.resources :tasks, :member => { :answer => :post, :play => :get }
  map.play '/play'    , :controller => 'tasks', :action => 'play'
  map.answer '/answer', :controller => 'tasks', :action => 'answer'
  
  map.resources :users, :only => [ :new, :edit, :create, :update ]
  
  map.namespace :admin do |admin|
    admin.resources :users, :collection => { :search_users => :get }
    admin.resources :tasks, :collection => { :order => :put }
    admin.resources :episodes
    admin.resources :solutions
    admin.resources :material
  end
  
  # Install the default route as the lowest priority.
  map.connect ':controller/:action/:id.:format'
  map.connect ':controller/:action/:id'
end
