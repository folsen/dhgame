module ApplicationHelper
  
  #return a home link based on what kind of user you are
  def home_link
    return link_to("root", root_path)
  end
  
  #return a linked image at the top that sends you to the correct index page
  def image_button_link
    return link_to( image_tag("/images/dhg-button.png", :id => "dhg-button"), root_path)
  end
  
  #return a link to the info
  def info_link
    return link_to("rules&info", :controller => :public, :action => :info)
  end
    
  #return a link to the help
  def help_link
    return link_to("help", :controller => :public, :action => :help)
  end
  
  #return the path for the task partial
  #TODO change to fit with paperclip
  def partial_path(task_object)
    path = "task/partials/task_#{task_object.partial}"
    #logger.info(path)
    return path
  end
  
  # TODO refactor this into somethign pretty
  #return a link for the user to click to start the game
  #based on where the user is right now
  #can return:
  #Start Game
  #Game hasnt started yet, it starts at...
  #You have finished the game
  #Proceed with the game...
  #The next episode starts at ... the first .. people will get .. minutes headstart if headstart is set
  #The game is still beeing prepared. Hang loose...
  def game_link
    progress = current_user.progresses
    first_episode = Episode.find_by_position(1)
    last_completed_task = progress.last.task unless progress.empty?
    next_episode = last_completed_task.episode.lower_item unless last_completed_task.nil?
    
    if first_episode.nil?
      return "<br />The Game is still being prepared. Hang loose..."
      
    elsif first_episode && first_episode.start_time > Time.zone.now
      return "<br />The Game will start at #{first_episode.start_time.to_s(:short)}"
      
    elsif progress.empty?
      return link_to("<br />Click to begin the adventure", "/play", :class => "load-remote")
      
    elsif !last_completed_task.last?
      return link_to("<br />You're not finished yet! Click here to continue.", "/play", :class => "load-remote")
      
    elsif next_episode.nil?
      return "<br />You have finished The Game! Congratulations, you are one of few."
      
    elsif next_episode.start_time < Time.zone.now || current_user.headstart_has_begun?(next_episode)
      return link_to("<br />Click to continue with the next episode", "/play", :class => "load-remote")
      
    elsif next_episode.headstart != 0
      return "<br />The next episode - #{next_episode.name} - starts at #{next_episode.start_time.to_s(:short)}, the best " + 
              "#{next_episode.headstart_count} people will get a #{next_episode.headstart} minute headstart!"
    else
      return "<br />The next episode - #{next_episode.name} - starts at #{next_episode.start_time.to_s(:short)}!"
    end
  end
  
end
