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
    if material.data_content_type == "image/jpg" || material.data_content_type == "image/gif" || material.data_content_type == "image/png" || material.data_content_type == "image/jpeg"
      inserted_html = ' <a href="/assets/' + material.data_file_name + '"><img width="400" src="/assets/' + material.data_file_name + '"/></a>'
    else
      inserted_html = ' <!-- /assets/' + material.data_file_name + '-->'
    end
    link_to_function material.data_file_name, "$('task_desc').value += '#{inserted_html}'"
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
  def episode_link_for_user(user_object)
    progress = user_object.progresses
    eps = Episode.find_by_position(1)
    next_ep = progress.last.episode.lower_item unless progress.empty?
    last_task = progress.last.task unless progress.empty?
    unless eps.nil?
      if progress.empty? && eps.start_time < Time.now
        return link_to("Start Game", task_path(Task.get_first_task))
      elsif progress.empty? && eps.start_time > Time.now
        "The Game hasn't started yet! It starts at #{eps.start_time.to_s(:short)}"
      elsif last_task.last? && progress.last.episode.last?
        return "You have finished The Game."
      elsif last_task.last? && !progress.last.episode.last? && (next_ep.start_time < Time.now || User.has_headstart(next_ep, user_object))
        return link_to("Proceed with the game...", task_path(next_ep.tasks.first))
      elsif last_task.last? && !progress.last.episode.last? && next_ep.start_time > Time.now
        if next_ep.headstart != 0
          return "The next episode - #{next_ep.name} - starts at #{next_ep.start_time.to_s(:short)}, the best " + 
                  "#{next_ep.headstart_count} people will get a #{next_ep.headstart} minute headstart!"
        else
          return "The next episode - #{next_ep.name} - starts at #{next_ep.start_time.to_s(:short)}!"
        end
      elsif !last_task.last?
        return link_to("Proceed with the game...", task_path(last_task.lower_item))
      else
        "A technical error occured, admin is notified!"
      end
    else
      "The Game is still being prepared. Hang loose..."
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
