class AdminController < ApplicationController
  before_filter :admin_required
    
  # Give all the users that are not admin, all the episodes and the current_user
  def index
    @users          = User.find_all_by_admin(0)
    @episodes       = Episode.find(:all)
  end
  
  #Rendes the task and episode creation page
  def create
    @episodes = Episode.find(:all)
  end
  
  #Renders the stats page for the admin
  def stats 
    @episodes       = Episode.find(:all)
    @users          = User.find_all_by_admin(0)
  end
  
  #This is used when ordering tasks and episodes on the creation page
  #Though i seriously have no idea what it actually does
  #TODO find out what this actually does
  def order
    episode_position = params[:episode_position]
    tasks = params["task_list_episode#{episode_position}"]
    logger.info(tasks.inspect)
    tasks.each_with_index do |id, position| 
        Task.find(id).update_attribute(:position, position + 1) 
    end 
    render :nothing => true
  end
    
end
