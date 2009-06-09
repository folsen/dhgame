class AdminController < ApplicationController
  before_filter :admin_required, :except => :api_wrong_answers
    
  # Give all the users that are not admin, all the episodes and the current_user
  def index
    @users          = User.find_all_by_admin(false)
    @episodes       = Episode.find(:all)
  end
  
  #Rendes the task and episode creation page
  def create
    @episodes = Episode.find(:all)
  end
  
  #Renders the stats page for the admin
  def stats 
    @episodes       = Episode.find(:all)
    @users          = User.find_all_by_admin(false)
  end
  
  def wrong_answers
    @wrong_answers = WrongAnswer.paginate(:page => params[:page], :order => "created_at DESC")
  end
  
  # This is used when ordering tasks and episodes on the creation page
  # it's called after a drop has been made and gets all the tasks
  # and updates their order in the database accordingly
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
    g = Gruff::Bar.new('450x250')
        g.theme = {
           :colors => ['#FFA400', '#3bb000', '#1e90ff', '#efba00', '#0aaafd'],
           :marker_color => '#aaa',
           :background_colors => ['#CEF2ED', '#fff']
         }

    g.hide_title = true
    g.hide_legend = true
    
    data_array = []
    
    prev_t = nil
    Episode.find(:all, :order => "position").each do |e|
      e.tasks.each do |t|
        if params[:type] == "progresses"
          data_array << t.progresses.count
        elsif params[:type] == "players"
          if t == Task.first_task
            data_array << User.count(:all, :conditions => {:admin => false}) - t.progresses.count
          else
            data_array << prev_t.progresses.count - t.progresses.count
          end
        end
        prev_t = t
      end
    end

    g.data("Players",data_array)
    
    g.labels = graph_labels
    
    
    send_data(g.to_blob, :disposition => 'inline', :type => 'image/png', :filename => "progress-stats.png")
  end
  
  def api_wrong_answers
    if params[:api_key] == "67e39387eead2e892ffb01a19e0e7ce7" && params[:since]
      params[:since] = Time.parse(params[:since])
      answers = WrongAnswer.find(:all, :conditions => ["created_at > ?", params[:since]])
      render :xml => answers.to_xml
    end
  end
  
  private
  
  def graph_labels
    labelhash = {}
    i = 0
    Episode.find(:all, :order => "position").each do |e|
      e.tasks.each do |t|
        labelhash[i] = {}
        labelhash[i] = t.name[0..5]
        i = i + 1
      end
    end
    return labelhash
  end
  
end
