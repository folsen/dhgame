class UsersController < ApplicationController
  
  # Changes the insertion of a fieldWithErrors div to adding the class fieldWithErrors on the input tag
  ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
    error_class = "fieldWithErrors"
    if html_tag =~ /<(input|textarea|select)[^>]+class=/
      class_attribute = html_tag =~ /class=['"]/
      html_tag.insert(class_attribute + 7, "#{error_class} ")
    elsif html_tag =~ /<(input|textarea|select)/
      first_whitespace = html_tag =~ /\s/
      html_tag[first_whitespace] = " class='#{error_class}' "
    end
    html_tag
  end

  before_filter :login_required, :except => [:new, :create, :edit]
  before_filter :admin_required, :only => [:index, :show, :destroy, :search_users]
  
  #list all users - only available to admin
  def index
    @users = User.paginate(:page => params[:page], :order => "team")
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
      redirect_to :controller => 'public', :action => 'home'
      flash[:notice] = "Thanks for signing up!"
    else
      render :action => 'new'
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
  
  #This is used when searching for users, it searces all attributes of the
  #users for the searched phrase and then replaces the content in "tableContent"
  #with the users found
	def search_users
	  query = "%" + params[:user][:query] + "%"
	  if params[:user][:query] == ""
	    users = User.paginate(:page => params[:page])
	  else
	    users = User.paginate(:page => params[:page], :conditions => ["login like ? OR firstname like ? OR lastname like ? OR team like ? OR nationality like ?", query, query, query, query, query])
    end
    render :update do |page|
	    page.replace_html "tableContent", {:partial => "users", :locals => {:users => users, :paginate => true }}
    end
  end
  
end
