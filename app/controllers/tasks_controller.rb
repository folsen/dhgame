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
    if @current_user.latest_attempt_at.nil?
      @time_left = 0
    else
      @time_left = (@current_user.latest_attempt_at+15-Time.zone.now).round
    end
    answer  = params[:answer][:text].downcase unless params[:answer][:text].nil?
    @task   = current_user.task
    if @time_left > 0
      render :partial => "tasks/show", :status => 418 and return
    end
    @current_user.update_attributes(:latest_attempt_at => Time.zone.now)
    # TODO rename to correct_answer?()
    if @task.check_answer(answer)
      current_user.make_progress(answer) unless authorized? #current_user.task changes unless admin
      if @task.last?
        render :partial => "tasks/index" and return
      end
      #Update the task for rendering later
      @task = @current_user.task
    else
      WrongAnswer.create(:user_id => current_user.id, :login => current_user.login, :task_id => @task.id, :answer => answer)
      logger.info("#{current_user.login} entered wrong password: #{params[:answer][:text]}")
      status = 404
    end
    render :partial => "tasks/show", :status => status || 200 and return
  end

end
