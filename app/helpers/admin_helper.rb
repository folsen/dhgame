module AdminHelper

  def alert_admin_to_lost_task(task_list)
    return_string = "These tasks have no episode:"
    task_list.each do |task|
      if task.episode_id.nil?
        return_string += "#{task.name}"
      end
    end
    return return_string
  end

  def colorized_row(user_object)
    if user_object.admin == 1
      return "<td class='admin_row'>"
    elsif user_object.crew == 1
      return "<td class='crew_row'>"
    else
      return "<td>"
    end
  end

  def episode_leader(episode_object)
    return link_to(episode_object.progresses.first.user.name, :action => :show_user,
      :id => episode_object.progresses.first.user.id) unless episode_object.progresses.empty?
  end

  #gets the latest completed tasks and returns the episode:position and who completed it first
  def leader(episodes)
    latest_task = nil
    episodes.each do |e|
      unless e.tasks.empty?
        e.tasks.each do |t|
          unless t.progresses.empty?
            latest_task = t
          end
        end
        if latest_task == nil
          return "NaN"
        end
      else
        return "NaN"
      end
    end
    return "#{latest_task.episode_id}:#{latest_task.position} - #{link_to latest_task.progresses.first.user.name,
      :action => :show_user, :id => latest_task.progresses.first.user.id}"
  end

  #this calculates the average time the task was completed
  #if there are more than 50 people that have completed it, it uses the first 50 people
  #to create the statistics, otherwise it gets kinda thrown off
  def average_time(task)
    total_time = 0
    unless task.progresses.empty?
      if task.progresses.length < 50
        task.progresses.each do |p|
          total_time += p.created_at.to_f
        end
        return (total_time/task.progresses.length)
      else
        task.progresses[0..49].each do |p|
          total_time += p.created_at.to_f
        end
        return (total_time/50)
      end
    else
      return "None shall pass!"
    end
  end

  #this calculates the average time to complete compared to the previous average time or
  #if it's the first task then compared to the start time, so this should give a pretty accurate
  #reading of how long it took to complete the task
  def average_completion_time(task)
    this_time = average_time(task)
    unless task.position == 1
      previous_time = average_time(Task.find(:first, :conditions => [" episode_id = ? AND position = ? ", task.episode_id, (task.position - 1)]))
      return "#{((this_time - previous_time) / 60 / 60).to_i}h #{((this_time - previous_time) / 60 % 60).to_i}m #{((this_time - previous_time) % 60 % 60).to_i}s"
    else
      return "#{((this_time - (task.episode.start_time.to_f - 32400)) / 60 / 60).to_i}h
        #{((this_time - task.episode.start_time.to_f - 32400) / 60 % 60).to_i}m
        #{((this_time - task.episode.start_time.to_f - 32400) % 60 % 60).to_i}s"
    end
  end

  #gives the best completion time instead of average as above
  def best_completion_time(task)
    unless task.progresses.empty?
      this_time = task.progresses.first.created_at.to_f
      if task.position == 1
        return "#{((this_time - (task.episode.start_time.to_f - 32400)) / 60 / 60).to_i}h
          #{((this_time - task.episode.start_time.to_f - 32400) / 60 % 60).to_i}m
          #{((this_time - task.episode.start_time.to_f - 32400) % 60 % 60).to_i}s"
      else
        previous_time = Task.find(:first, :conditions => [" episode_id = ? AND position = ? ", task.episode_id, (task.position - 1)]).progresses.first.created_at.to_f
        return "#{((this_time - previous_time) / 60 / 60).to_i}h #{((this_time - previous_time) / 60 % 60).to_i}m #{((this_time - previous_time) % 60 % 60).to_i}s"
      end
    end
  end

  #count the number of users that are currenlty on a specific task and return the results as an array
  def get_tasks_playercount
    current_task_array = []
    users = User.find(:all, :conditions => "admin = 0")
    users.each do |user|
      progresses = user.progresses
      if progresses.empty?
        current_task_array << "1.1"
      else
        current_task = progresses.last.task.lower_item
        unless current_task.nil?
          current_task_array << "#{current_task.episode.position}.#{current_task.position}"
        else
          current_ep = progresses.last.task.episode.lower_item
          current_task_array << "#{current_ep.position}.1" unless current_ep.nil?
        end
      end
    end
    return_array = []
    task_hash = current_task_array.group_by {|task| task}
    
    task_hash.each do |task, tasks|
      return_array << [task, tasks.length]
    end
    return return_array.sort
  
  end
  
  def get_teammates(user)
    teammates = User.find(:all, :conditions => ["team = ?", user.team]) unless user.team.empty? || user.team == "Single Player"
    if teammates.nil?
      return []
    else
      return teammates
    end
  end

end
