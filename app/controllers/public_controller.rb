class PublicController < ApplicationController
  layout 'standard'

  def index
    unless session[:user_id].nil?
      @user = User.find_by_id(session[:user_id])
    else
      @user = nil
    end
  end
  
  def info
  end
  
  def help
  end
    
    def method_missing(name, *args)
  		redirect_to :controller => 'public', :action => ''
  	end
    
  def login 
    session[:user_id] = nil 
    if request.post? 
      user = User.authenticate(params[:name], params[:password]) 
      if user
        session[:user_id] = user.id 
        if User.check_if_admin(user)
          session[:admin] = true
          redirect_to :controller => :admin, :action => :index and return
        end
        redirect_to :controller => :task  , :action => :index and return
      else 
        flash[:notice] = "Invalid user/password combination"
        redirect_to :controller => :public, :action => :index and return
      end 
    end 
  end
  
  def logout
    session[:user_id] = nil
    User.active_user = nil
    flash[:notice] = "Logged out."
    redirect_to :action => :index
  end

    
  def new 

      if request.post?
        @user = User.new(params[:user])
        if @user.save
          flash[:notice] = "User #{@user.name} was created. You can log in now."
          redirect_to :action => :index and return
        end
      end
  end
  



end
