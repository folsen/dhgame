class TaskController < ApplicationController
  before_filter :authorize
  layout 'standard'

  #render the index action, if you have completed the game, redirect to done
  def index
    @user = User.find_by_id(session[:user_id])
    @progress = @user.progresses
    if !@progress.empty? && @progress.last.task.is_last? && @progress.last.episode.is_last?     
      redirect_to :action => :done and return
    end
  end

  #render the done page
  #TODO what is this code here? it can't possibly do anything?
  def done
    @user = User.find_by_id(session[:user_id])
    progress = @user.progresses
  end
  
  #render the edit page for themselves
  def edit_user
    @user = User.find_by_id(session[:user_id])
  end
  
  #show a task, requested via id in the params
  #TODO @user is rendered everywhere, there will be no need for that when restful_auth is in place fix that later
  #TODO refactor this code so it's understandable
  def show
    req_task = params[:id]
    @user = User.find_by_id(session[:user_id])
    begin
      @task = Task.find(req_task)
    rescue ActiveRecord::RecordNotFound, ActiveRecord::RecordInvalid
      flash[:notice] = "Could not find that task!"
      redirect_to :action => :index and return
    else
      unless Task.validate_task_request?(@task, @user)
        flash[:notice] = "Cheating is bad karma!"
        redirect_to :action => :index and return
      end
    end
  end
  
  #TODO remove?
  def method_missing(name, *args)
		redirect_to :controller => 'task', :action => ''
	end
  
  
  #TODO Rewrite this!
  def answer
    answer  = params[:answer][:text].downcase unless params[:answer][:text].nil?
    task    = Task.find_by_id(params[:answer][:task_id])
    #TODO remove User.active_user
    if Task.validate_task_request?(task, User.active_user)
      if task.check_answer(answer)
        User.active_user.make_progress(task, answer)
        if task.is_last?
          redirect_to :action => :index and return
        end
        task_id = Task.get_id_for_task(task) #gets the id for the next task
        redirect_to :action => :show, :id => task_id and return
      else
        redirect_to :action => :show, :id => task.id and return
      end
    else # Else for Task.validate_task_request?
      flash[:notice] = "Could not find that task!"
      redirect_to :action => :index and return
    end
  end
  
  

  
  
  # Ajaxy junk below!
  #TODO fix all this shit somehow!
  
  def update_email
    user = User.find_by_id(params[:id])
    user.update_attribute(:email, params[:value])
    render :text => user.email
  end
  
  def update_phone
     user = User.find_by_id(params[:id])
     user.update_attribute(:phone, params[:value])
     render :text => user.phone
  end
   
  def update_first_name
    user = User.find_by_id(params[:id])
    user.update_attribute(:first_name, params[:value])
    render :text => user.first_name
  end
  
  def update_last_name
    user = User.find_by_id(params[:id])
    user.update_attribute(:last_name, params[:value])
    render :text => user.last_name
  end
  
  def update_row
      user = User.find_by_id(params[:id])
      user.update_attribute(:row, params[:value])
      render :text => user.row
  end
  
  def update_seat
      user = User.find_by_id(params[:id])
      user.update_attribute(:seat, params[:value])
      render :text => user.seat
  end
  
  def update_team
    user = User.find_by_id(params[:id])
    user.update_attribute(:team, params[:value])
    render :text => user.team
  end

end
