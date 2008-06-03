module TaskHelper
  
  
  def episode_link_for_user(user_object)
    progress = user_object.progresses
    eps = Episode.find_by_position(1)
    next_ep = progress.last.episode.lower_item unless progress.empty?
    last_task = progress.last.task unless progress.empty?
    unless eps.nil?
      if progress.empty? && eps.start_time < Time.now
        return link_to("Start Game", :action => :show, :id => Task.get_first_task_id)
      elsif progress.empty? && eps.start_time > Time.now
        "The Game hasn't started yet! It starts at #{eps.start_time.to_s(:short)}"
      elsif last_task.is_last? && progress.last.episode.is_last?
        return "You have finished The Game."
      elsif last_task.is_last? && !progress.last.episode.is_last? && (next_ep.start_time < Time.now || User.has_headstart(next_ep, user_object))
        return link_to("Proceed with the game...", :action => :show, :id => next_ep.tasks.first.id)
      elsif last_task.is_last? && !progress.last.episode.is_last? && next_ep.start_time > Time.now
        if next_ep.headstart != 0
          return "The next episode - #{next_ep.name} - starts at #{next_ep.start_time.to_s(:short)}, the best " + 
                  "#{next_ep.headstart_count} people will get a #{next_ep.headstart} minute headstart!"
        else
          return "The next episode - #{next_ep.name} - starts at #{next_ep.start_time.to_s(:short)}!"
        end
      elsif !last_task.is_last?
        return link_to("Proceed with the game...", :action => :show, :id => last_task.lower_item.id)
      else
        "A technical error occured, admin is notified!"
      end
    else
      "The Game is still being prepared. Hang loose..."
    end
  end
  
  def result_link_for_user(user_object)
    if user_object.progresses.length == 0
      return "You haven't got any results yet!"
    else
      return "You were the #{user_object.progresses.last.position}th person to finish!"
    end
  end
  
  def progress_bar(task_object,user_object)
    task_this = task_object.position-1
    task_count = Task.count("id", :conditions => "episode_id = #{task_object.episode_id}") 
    logger.info(task_this.inspect)
    logger.info(task_count.inspect)
    task_percentage = ((task_this.to_f/task_count.to_f)*100).round
    return task_percentage
  end
  


end
