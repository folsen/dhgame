class TaskusersController < ApplicationController
  def show
    @task = Task.find_by_id(params[:id])
    @users = User.paginate_by_task_id(params[:id], :page => params[:page], :order => "team")
  end
end
