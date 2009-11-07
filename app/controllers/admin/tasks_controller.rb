class Admin::TasksController < ApplicationController

  layout 'admin'
  
  before_filter :admin_required
  
  def index
    @tasks = Task.all
  end
  
  #show a task, requested via id in the params
  def show
    begin
      @task = Task.find(params[:id])
    rescue ActiveRecord::RecordNotFound, ActiveRecord::RecordInvalid
      flash[:notice] = "Could not find that task!"
      render :partial => "public/home" and return
    else
      render :partial => "tasks/show"
    end
  end
  
  
  #render the page to create a new task
  def new
    @task = Task.new
    @episodes = Episode.all
  end
  
  
  #create and save the task from the paramaters from the form - only available to admins
  def create
    @task = Task.new(params[:task])
    if @task.save
      flash[:notice] = "Task #{@task.name} was created!"
      redirect_to "/admin/create" 
    else
      flash[:error] = "Could not create task!"
      redirect_to :action => :new
    end
  end
  
  #edit a task - only available to admins
  def edit
    @task = Task.find(params[:id])
    @episodes = Episode.all
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
      redirect_to "/admin/create" 
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
    redirect_to "/admin/create" 
    
  end

  # set the order of the tasks - called with ajax from the create page on drag&drop
  def order
    params[:tasks].split(",").each_with_index do |id, position|
      Task.find_by_id(id).update_attributes(:position => position+1)
    end
    render :nothing => true
  end

end