class UsersController < ApplicationController
  before_filter :login_required, :except => [:new, :create]
  before_filter :admin_required, :only => [:index, :show, :destroy]
  
  #list all users - only available to admin
  def index
    @users = User.all
  end
  
  #show a single user - only available to admin
  def show
    @user = User.find(params[:id])
  end

  # render new.rhtml
  def new
    @user = User.new
  end
  
  #render the edit, however only allow admins to edit people other than themselves
  def edit
    if !authorized? && params[:id] != current_user.id.to_s
      redirect_to edit_user_path(current_user)
    end  
    @user = User.find(params[:id])
  end
 
  def create
    logout_keeping_session!
    @user = User.new(params[:user])
    success = @user && @user.save
    if success && @user.errors.empty?
      # Protects against session fixation attacks, causes request forgery
      # protection if visitor resubmits an earlier form using back
      # button. Uncomment if you understand the tradeoffs.
      # reset session
      self.current_user = @user # !! now logged in
      redirect_to("/")
      flash[:notice] = "Thanks for signing up!"
    else
      flash[:error]  = "We couldn't set up that account, sorry.  Please try again, or contact an admin (link is above)."
      render :action => 'new'
    end
  end
  
  def update
    @user = User.find(params[:id])
    @user.update_attributes(params[:user])
    if @user.errors.empty?
      flash[:notice] = "Your changes are saved"
      redirect_to edit_user_path(@user)
    else
      flash[:error] = "We couldn't perform your changes :("
      render :action => 'edit'
    end
  end
  
  #remove a user
  def destroy
    user = User.find_by_id(params[:id])
    
    if user.destroy
      flash[:notice] = "User #{user.login} was killed and can never come back!"
    else
      flash[:notice] = "Ooops, something went wrong. Read teh logs...!"
    end
    redirect_to :action => :users 
  end
  
end
