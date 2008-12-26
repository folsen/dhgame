class AdminController < ApplicationController
    
    # Give all the users that are not admin, all the episodes and the current_user
    #TODO refactor out @user to something application specific, should not have to do this every time
    def index
      @users          = User.find_all_by_admin(0)
      @episodes       = Episode.find(:all)
      @user           = current_user
      
    end
    
    #Rendes the task and episode creation page
    def create
      @episodes = Episode.find(:all)
    end
    
    #Renders a single task for admin
    def show
      begin 
        @task = Task.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        flash[:error] = "Can't find task without ID!"
        redirect_to :action => :index 
      end
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
    
    #This is used when searching for users, it searces all attributes of the
    #users for the searched phrase and then replaces the content in "tableContent"
    #with the users found
  	def search_users
  	  query = "%" + params[:user][:name] + "%"
  	  if params[:user][:name] == ""
  	    users = User.find(:all)
  	  else
  	    users = User.find(:all, :conditions => ["name like ? OR first_name like ? OR last_name like ? OR team like ? OR nationality like ?", query, query, query, query, query])
	    end
      render :update do |page|
  	    page.replace_html "tableContent", {:partial => "admin/users", :locals => {:users => users}}
	    end
	  end
    
    #just update the episode, called from the edit page
    def update_episode
      episode = Episode.find_by_id(params[:id])
      if episode.update_attributes(params[:episode])
        flash[:notice] = "Episode updated."
        redirect_to :action => :create 
      else
        flash[:error] = "Could not update!"
        redirect_to :action => :create 
      end
      
    end
	  
	  #render the edit page for the id given
	  def edit_episode
	    episode_id = params[:id]
	    @episode = Episode.find_by_id(episode_id)
    end
    
    #tries to delete an episode
    #TODO find out what happens with the tasks in this episode at this point
    def delete_episode
      episode_id = params[:id]
      episode = Episode.find_by_id(episode_id)
      if episode.destroy
        flash[:notice] = "Episode deleted"
      else
        flash[:notice] = "Episode could not be deleted. Check the log!"
      end  
      redirect_to :action => :create 
    end
    
    #render the page to create a new episode
    #TODO remove Episode.new() from here?
    def new_episode
      @episode = Episode.new()
    end
    
    #create and save the episode from the paramaters from the form
    def save_episode
      @episode = Episode.new(params[:episode])
      if @episode.save
        flash[:notice] = "Episode #{@episode.name} was created!"
        redirect_to :action => :create 
      else
        flash[:error] = "Episode could not be created!"
        redirect_to :action => :new_episode 
      end
    end
    
    #remove an answer and re-render the answer_list
    def delete_answer
      answer_id = params[:id]
      answer = Answer.find_by_id(answer_id)
      if answer.destroy
        render :update do |page|
          page.replace_html "ajax_container_for_answers", 
          {:partial => "admin/answer_list", :locals => {:answers => answer.task.answers}}
        end
      else
        render :update do |page|
          page.alert "Could not delete answer!"
        end
      end
    end
    
    # Ajaxy thingees below
    
    #change the partial name
    #TODO somehow merge all these things into one, too much repeating right now
    def update_partial_identifier
      task = Task.find_by_id(params[:id])
      task.update_attribute(:partial, params[:value])
      render :text => task.partial
    end
    
    #create a new answer and re-render the answer_list
    #TODO refactor out the rendering - it is used multiple times
    def add_answer
      task = Task.find_by_id(params[:id])
      answer = Answer.create(:answer => "Click to edit", :task_id => task.id)
      render :update do |page|
        page.insert_html :bottom, "ajax_container_for_answers", {:partial => "answer_row", :locals => {:task => task, :answer => answer }}
      end
    end
    
end
