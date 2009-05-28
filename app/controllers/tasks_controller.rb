class TasksController < ApplicationController
  before_filter :login_required
  before_filter :admin_required, :except => [:index, :show, :answer]

  #render the index action, if you have completed the game, render that
  def index

  end
  
  #show a task, requested via id in the params
  #TODO refactor this code so it's understandable
  def show
    begin
      @task = Task.find(params[:id])
    rescue ActiveRecord::RecordNotFound, ActiveRecord::RecordInvalid
      flash[:notice] = "Could not find that task!"
      redirect_to :action => :index 
    else
      if !authorized? && !current_user.validate_task_request?(@task)
        flash[:notice] = "Cheating is bad karma!"
        redirect_to :action => :index 
      end
    end
  end
  
  #render the page to create a new task
  def new
    @task = Task.new
    @episodes = Episode.all
  end
  
  #edit a task - only available to admins
  def edit
    @task = Task.find(params[:id])
    @episodes = Episode.all
  end
  
  #create and save the task from the paramaters from the form - only available to admins
  def create
    @task = Task.new(params[:task])
    if @task.save
      flash[:notice] = "Task #{@task.name} was created!"
      redirect_to :controller => :admin, :action => :create 
    else
      flash[:error] = "Could not create task!"
      redirect_to :action => :new
    end
  end
  
  #update task  - only available to admins
  def update
    params[:task][:existing_material_attributes] ||= {}
    params[:task][:existing_answer_attributes] ||= {}

    @task = Task.find(params[:id])
    #if you change the episode, set the position of the task to last of the new episode
    if params[:task][:episode_id] != @task.episode_id.to_s
      params[:task][:position] = Episode.find(params[:task][:episode_id]).tasks.count + 1
    end
    @task.update_attributes(params[:task])
    if @task.errors.empty?
      flash[:notice] = "Your changes are saved"
      redirect_to :controller => :admin, :action => :create
    else
      flash[:error] = "We couldn't perform your changes :("
      render :action => 'edit'
    end
  end
    
  #destroy the task and all of it's relations - only available to admins
  def destroy
    task = Task.find_by_id(params[:id])
        
    if task.destroy
      flash[:notice] = "Task was deleted!"
    else
      flash[:error] = "Task could not be deleted!"
    end
    redirect_to :controller => :admin, :action => :create
    
  end

  #try to answer a task from a form
  def answer
    answer  = params[:answer][:text].downcase unless params[:answer][:text].nil?
    task    = current_user.task
    if task.check_answer(answer)
      current_user.make_progress(answer) unless authorized? #current_user.task changes unless admin
      if task.last?
        redirect_to tasks_path and return
      end
    else
      WrongAnswer.create(:user_id => current_user.id, :task_id => task.id, :answer => answer)
      logger.info("#{current_user.login} entered wrong password: #{params[:answer][:text]}")
    end
    redirect_to task_path(current_user.task)
  end

end
