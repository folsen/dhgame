class TasksController < ApplicationController
  before_filter :login_required

  #render the index action, if you have completed the game, render that
  def index

  end
  
  #display the task that a user is currently on
  def play
    @task = @current_user.task
    if @current_user.validate_task_request?(@task)
      render :partial => "tasks/show" and return
    else
      redirect_to :action => "home", :controller => "public" and return
    end
  end

  #try to answer a task from a form
  def answer
    answer  = params[:answer][:text].downcase unless params[:answer][:text].nil?
    task    = current_user.task
    if task.check_answer(answer)
      current_user.make_progress(answer) unless authorized? #current_user.task changes unless admin
      if task.last?
        render :partial => "tasks/index" and return
      end
    else
      WrongAnswer.create(:user_id => current_user.id, :login => current_user.login, :task_id => task.id, :answer => answer)
      logger.info("#{current_user.login} entered wrong password: #{params[:answer][:text]}")
      status = 404
    end
    @task = @current_user.task
    render :partial => "tasks/show", :status => status || 200
  end

end
