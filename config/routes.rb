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
  map.resources :users
  map.resources :tasks, :member => { :answer => :post }
  
  map.resources :material
  
  

  map.root :controller => "public", :action => "index"

  # Install the default route as the lowest priority.
  map.connect ':controller/:action/:id.:format'
  map.connect ':controller/:action/:id'
end
