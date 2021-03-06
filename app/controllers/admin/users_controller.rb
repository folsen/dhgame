class Admin::UsersController < ApplicationController
  layout 'admin'
  
  before_filter :admin_required
  
  #list all users - only available to admin
  def index
	  if params[:query].nil? || params[:query] == ""
	    @users = User.paginate(:page => params[:page], :order => "team")
	  else
	    query = "%" + params[:query].to_s + "%"
	    @users = User.paginate(:page => params[:page], :conditions => ["login like ? OR firstname like ? OR lastname like ? OR team like ? OR nationality like ?", query, query, query, query, query])
    end
    respond_to do |wants|
      wants.js { render :partial => "users", :locals => { :users => @users, :paginate => true } }
      wants.html
    end
  end
  
  #show a single user - only available to admin
  def show
    @user = User.find(params[:id])
  end
  
  #render the edit, however only allow admins to edit people other than themselves
  def edit
    if !logged_in?
      @user = User.new
      render :action => "new", :layout => false and return
    end
    if !authorized? && params[:id] != current_user.id.to_s
      @user = current_user
    else
      @user = User.find(params[:id])
    end
  end
 
  def update
    @user = User.find(params[:id])
    #protect from form-forgery, only admins are allowed to change admin status
    if @user.admin != params[:user][:admin] && !authorized?
      params[:user][:admin] = @user.admin
    end
    @user.update_attributes(params[:user])
    if @user.errors.empty?
      flash[:notice] = "Your changes are saved"
      redirect_to edit_admin_user_path(@user)
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
    redirect_to :action => 'index'
  end

end