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
  
  def graph
    g = Gruff::Bar.new('480x210')
        g.theme = {
           :colors => ['#FFA400', '#3bb000', '#1e90ff', '#efba00', '#0aaafd'],
           :marker_color => '#aaa',
           :background_colors => ['#CEF2ED', '#fff']
         }

    g.hide_title = true
    g.hide_legend = true
    
    data_array = []
    
    Task.all.each do |t|
      if params[:type] == "progresses"
        data_array << t.progresses.count
      elsif params[:type] == "players"
        data_array << t.users.count
      end
    end
    
    g.data("Players",data_array)
    
    g.labels = graph_labels
    
    
    send_data(g.to_blob, :disposition => 'inline', :type => 'image/png', :filename => "progress-stats.png")
  end
  
  private
  
  def graph_labels
    labelhash = {}
    Episode.all.each do |e|
      e.tasks.each_with_index do |t, i|
        labelhash[i] = {}
        labelhash[i] = e.position.to_s + "." + t.position.to_s
      end
    end
    return labelhash
  end
  
end
