# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  # Pick a unique cookie name to distinguish our session data from others'
  session :session_key => '_cassi_session_id'
  private
  
  def check_for_admin
    user = User.find_by_id(session[:user_id])
    if !user.admin.nil? && user.admin == 1
      true
    else
      flash[:notice] = "You're not admin!"
      redirect_to :controller => :task, :action => :index and return
    end
  end
  
  def method_missing(name, *args)
		redirect_to :controller => 'task', :action => ''
	end
  
  def authorize 
    user = User.find_by_id(session[:user_id]) 
    unless user
      flash[:notice] = "Please log in" 
      redirect_to(:controller => "public", :action => "index") 
    else
      User.active_user   = user
      @user               = user
    end     
  end
  
end
