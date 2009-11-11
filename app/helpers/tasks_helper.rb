module TasksHelper

  #add link for first argument, material or answer
  #params type = material || answer or the shit breaks
  def add_link(type, name)
    link_to_function name do |page|
      page.insert_html :bottom, type + "s", :partial => type, :object => type.capitalize.constantize.new
    end
  end
  
  #create the fields declarations for a certain object
  def fields_for_object(object, &block)
    prefix = object.new_record? ? 'new' : 'existing'
    fields_for("task[#{prefix}_#{object.class.name.downcase}_attributes][]", object, &block)
  end
  
  #create a link for inserting proper html into the description box
  def insert_html_link(material)
    link_to_function material.data_file_name, "$('task_desc').value += '#{material.example_usage}'"
  end
  
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
      return link_to("<br />Click to begin the adventure", "/play")
      
    elsif !last_completed_task.last?
      return link_to("<br />You're not finished yet! Click here to continue.", "/play")
      
    elsif next_episode.nil?
      return "<br />You have finished The Game! Congratulations, you are one of few."
      
    elsif next_episode.start_time < Time.zone.now || current_user.headstart_has_begun?(next_episode)
      return link_to("<br />Click to continue with the next episode", "/play")
      
    elsif next_episode.headstart != 0
      return "<br />The next episode - #{next_episode.name} - starts at #{next_episode.start_time.to_s(:short)}, the best " + 
              "#{next_episode.headstart_count} people will get a #{next_episode.headstart} minute headstart!"
    else
      return "<br />The next episode - #{next_episode.name} - starts at #{next_episode.start_time.to_s(:short)}!"
    end
  end
  
  #return how many percent the user has completed
  #TODO check to see if this can be improved
  def progress_bar(task_object,user_object)
    task_this = task_object.position-1
    task_count = task_object.episode.tasks.length
    #logger.info(task_this.inspect)
    #logger.info(task_count.inspect)
    task_percentage = ((task_this.to_f/task_count.to_f)*100).round
    return task_percentage
  end
  
end
