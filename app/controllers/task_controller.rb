class TaskController < ApplicationController
  before_filter :authorize
  layout 'standard'

  def index
    @user = User.find_by_id(session[:user_id])
    @progress = @user.progresses
    if !@progress.empty? && @progress.last.task.is_last? && @progress.last.episode.is_last?     
      redirect_to :action => :done and return
    end
  end

  def done
    @user = User.find_by_id(session[:user_id])
    progress = @user.progresses
  end
  
 
  
  def info
  end
  
  def help
  end
  
  def edit_user
    @user = User.find_by_id(session[:user_id])
  end
  
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
  
  def method_missing(name, *args)
		redirect_to :controller => 'task', :action => ''
	end
  
  
  ## Rewrite this!
   
  def answer
    answer  = params[:answer][:text].downcase unless params[:answer][:text].nil?
    task    = Task.find_by_id(params[:answer][:task_id])
    if Task.validate_task_request?(task, User.active_user)
      if task.check_answer(answer)
        User.active_user.make_progress(task, answer)
        if task.is_last?
          redirect_to :action => :index and return
        end
        task_id = Task.get_id_for_task(task)
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
