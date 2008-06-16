class AdminController < ApplicationController
    before_filter :authorize, :check_for_admin
    layout 'standard'
    
    def index
      @users          = User.find_all_by_admin(0)
      @episodes       = Episode.find(:all)
      @user           = User.find_by_id(session[:user_id])
      
    end
    
    def create
      @episodes = Episode.find(:all)
    end
      
    def timeline
      
    end
    
    def show
      begin 
        @task = Task.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        flash[:error] = "Can't find task without ID!"
        redirect_to :action => :index and return
      end
    end
    
    def stats 
      @episodes       = Episode.find(:all)
      @users          = User.find_all_by_admin(0)
    end
    
    
    def method_missing(name, *args)
  		redirect_to :controller => 'admin', :action => ''
  	end
  	
  	def order
  	  episode_position = params[:episode_position]
      tasks = params["task_list_episode#{episode_position}"]
      logger.info(tasks.inspect)
      tasks.each_with_index do |id, position| 
          Task.find(id).update_attribute(:position, position + 1) 
      end 
      render :nothing => true
    end
    
 
  	
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

    def update_episode
      episode = Episode.find_by_id(params[:id])
      if episode.update_attributes(params[:episode])
        flash[:notice] = "Episode updated."
        redirect_to :action => :create and return
      else
        flash[:error] = "Could not update!"
        redirect_to :action => :create and return
      end
      
    end
	  
	  def edit_episode
	    episode_id = params[:id]
	    @episode = Episode.find_by_id(episode_id)
    end
    
    def delete_episode
      episode_id = params[:id]
      episode = Episode.find_by_id(episode_id)
      if episode.destroy
        flash[:notice] = "Episode deleted"
      else
        flash[:notice] = "Episode could not be deleted. Check the log!"
      end  
      redirect_to :action => :index and return
    end
    
    
    def users
      @users = User.find(:all)
    end
    
    #fulhack
    def progresses
      @progresses = Progresses.find(:all)
      episodes = Episode.find(:all)
      @episode = episode.last
    end
    
    def edit_user
      @admin_user = User.find_by_id(session[:user_id])
      @user = User.find_by_id(params[:id])
      if @user.nil?
        flash[:error] = "No user there!"
        redirect_to :action => :index and return
      end
    end
    
    def show_user
      @user = User.find_by_id(params[:id])
      if @user.nil?
        flash[:error] = "No user there!"
        redirect_to :action => :index and return
      end
    end
  
    def new_task
      @task = Task.new()
      @episodes = Episode.find(:all, :conditions => "start_time > '#{Time.now.to_s(:db)}'")
    end
    
    def new_episode
      @episode = Episode.new()
    end
    
    def save_task
      @task = Task.new(params[:task])
      if @task.save
        flash[:notice] = "Task #{@task.name} was created!"
        redirect_to :action => :create and return
      else
        flash[:error] = "Could not create task!"
        redirect_to :action => :new_task and return
      end
    end
    
    def save_episode
      @episode = Episode.new(params[:episode])
      if @episode.save
        flash[:notice] = "Episode #{@episode.name} was created!"
        redirect_to :action => :create and return
      else
        flash[:error] = "Episode could not be created!"
        redirect_to :action => :new_episode and return
      end
    end
    
    def delete_answer
      answer_id = params[:id]
      answer = Answer.find_by_id(answer_id)
      if answer.destroy
        render :update do |page|
          page.replace_html "ajax_container_for_answers", {:partial => "admin/answer_list", :locals => {:answers => answer.task.answers}}
        end
      else
        render :update do |page|
          page.alert "Could not delete answer!"
        end
      end
    end
    
    def delete_task
      task = Task.find_by_id(params[:id])
      if task.destroy
        flash[:notice] = "Task was deleted!"
        redirect_to :action => :create and return
      else
        flash[:error] = "Task could not be deleted!"
        redirect_to :action => :create and return
      end
    end
    
    def delete_user
      id  = params[:id]
      u   = User.find_by_id(id)
      if u.destroy
        flash[:notice] = "User #{u.name} was killed and can never come back!"
      else
        flash[:notice] = "Ooops, something went wrong. Read teh logs...!"
      end
      redirect_to :action => :index and return
    end
    # Ajaxy thingees below
    
    def update_partial_identifier
      task = Task.find_by_id(params[:id])
      task.update_attribute(:partial, params[:value])
      render :text => task.partial
    end
    
    def add_answer
      task = Task.find_by_id(params[:id])
      answer = Answer.create(:answer => "Click to edit", :task_id => task.id)
      render :update do |page|
        page.insert_html :bottom, "ajax_container_for_answers", {:partial => "answer_row", :locals => {:task => task, :answer => answer }}
      end
    end
    
    def update_task_name
      task = Task.find_by_id(params[:id])
      task.update_attribute(:name, params[:value])
      render :text => task.name
    end
    
    def update_task_desc
        task = Task.find_by_id(params[:id])
        task.update_attribute(:desc, params[:value])
        render :text => task.desc
    end
      
    def update_answer
        answer = Answer.find_by_id(params[:id])
        answer.update_attribute(:answer, params[:value])
        render :text => answer.answer
    end
    
    def update_admin
      user = User.find_by_id(params[:id])
      user.update_attribute(:admin, params[:value])
      render :text => user.admin
    end
    
end
