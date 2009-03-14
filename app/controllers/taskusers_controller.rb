class TaskusersController < ApplicationController
  def show
    @task = Task.find_by_id(params[:id])
    @users = []
    User.find(:all, :conditions => {:admin => false}).each do |u|
      if u.task == @task
        @users << u
      end
    end
  end
end
