module AdminHelper
  
  #return a string of all the tasks that have no name
  #TODO change and implement this in admin/create
  def alert_admin_to_lost_task(task_list)
    return_string = "These tasks have no episode:"
    task_list.each do |task|
      if task.episode_id.nil?
        return_string += "#{task.name}"
      end
    end
    return return_string
  end
  
  #returns a link to the winner of the episode
  def episode_winner(episode_object)
    if episode_object.tasks.empty? || episode_object.tasks.last.progresses.empty?
      return "No winner yet"
    end
    
    user = episode_object.tasks.last.progresses.first.user
    return link_to(user.login, user_path(user))
  end

  #gets the latest completed tasks and returns: episode:task - who completed it first
  def leader(episodes)
    latest_task = nil
    episodes.each do |e|
      unless e.tasks.empty?
        #go through the tasks in order and set the latest_task to this task
        #when you get to a task with no progresses it doesnt set it
        #so the result is you get the last task that has progresses
        e.tasks.each do |t|
          unless t.progresses.empty?
            latest_task = t
          end
        end
        if latest_task == nil
          return "No progresses made"
        end
      else
        return "No tasks in episode"
      end
    end
    user = latest_task.progresses.first.user
    return "#{latest_task.episode.position}:#{latest_task.position} - #{link_to user.login, user_path(user)}"
  end

  #this calculates the average time the task was completed
  #if there are more than 50 people that have completed it, it uses the first 50 people
  #to create the statistics, otherwise it gets kinda thrown off
  def average_time(task)
    total_time = 0
    unless task.progresses.empty?
      
      task.progresses[0..49].each do |p|
        total_time += p.created_at.to_f
      end
      return (total_time/task.progresses[0..49].length)

    else
      return "None shall pass!"
    end
  end

  #this calculates the average time to complete compared to the previous average time or
  #if it's the first task then compared to the start time, so this should give a pretty accurate
  #reading of how long it took to complete the task
  #TODO refactor for understandability
  def average_completion_time(task)
    this_time = average_time(task)
    if task.position == 1
      return time_difference(this_time, task.episode.start_time.to_f)
    else
      previous_time = average_time(Task.find(:first, :conditions => [" episode_id = ? AND position = ? ", 
        task.episode_id, (task.position - 1)]))
      return time_difference(this_time, previous_time)
    end
  end

  #gives the best completion time instead of average as above
  def best_completion_time(task)
    unless task.progresses.empty?
      this_time = task.progresses.first.created_at.to_f
      if task.position == 1
        return time_difference(this_time, task.episode.start_time.to_f)
      else
        previous_time = Task.find(:first, :conditions => [" episode_id = ? AND position = ? ", 
          task.episode_id, (task.position - 1)]).progresses.first.created_at.to_f
        return time_difference(this_time, previous_time)
      end
    end
  end
  
  #returns a formatted string of a difference between two times
  #params: the two times to be compared, given in float
  def time_difference(this_time, previous_time)
    return "#{((this_time - previous_time) / 60 / 60).to_i}h 
    #{((this_time - previous_time) / 60 % 60).to_i}m 
    #{((this_time - previous_time) % 60 % 60).to_i}s"
  end

  #count the number of users that are currently on a specific task returns the results as an array
  #TODO refactor, use database instead and store the users current task in there
  #this is very bad code
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
  
  #build a chart 
  #TODO replace with some plugin
  def get_task_chart_labels
    task_chart_labels = ""
    episodes = Episode.find(:all)
    episodes.each do |e|
      e.tasks.each do |t|
        task_chart_labels = task_chart_labels + "|" + e.position.to_s + "." + t.position.to_s
      end
    end
    return task_chart_labels
  end
  
  def get_progresses_chart_data
    progresses_chart_data = ""
    episodes = Episode.find(:all)
    episodes.each do |e|
      e.tasks.each do |t|
        if e.last? && t.last?
          progresses_chart_data = progresses_chart_data + t.progresses.length.to_s
        else
          progresses_chart_data = progresses_chart_data + t.progresses.length.to_s + ","
        end
      end
    end
    return progresses_chart_data
  end
  def get_progresses_chart_labels
    progresses_chart_labels = ""
    episodes = Episode.find(:all)
    episodes.each do |e|
      e.tasks.each do |t|
        progresses_chart_labels = progresses_chart_labels + "|" + t.progresses.length.to_s
      end
    end
    return progresses_chart_labels
  end
  
  #generates a link for the google api chart
  def get_progresses_chart_link
    link = "http://chart.apis.google.com/chart?cht=bvs&chs=500x300&chco=FFEA63&chds=0,"
    link = link + @users.length.to_s 
    link = link + "&chd=t:"
    link = link + get_progresses_chart_data
    link = link + "&chxl=1:"
    link = link + get_task_chart_labels
    link = link + "|0:"
    link = link + get_progresses_chart_labels
    link = link + "|2:|0|"
    link = link + @users.length.to_s
    link = link + "&chxt=x,x,y&chf=bg,s,000000"
    return link
  end
  
  def get_player_count_chart_link
    chart_data = ""
    chart_labels = ""
    task_labels = ""
    link = "http://chart.apis.google.com/chart?cht=bvs&chs=500x300&chco=FFEA63&chds=0,"
    link = link + @users.length.to_s 
    link = link + "&chd=t:"
    get_tasks_playercount.each do |count|
      chart_data = chart_data + "," + count[1].to_s
      chart_labels = chart_labels + "|" + count[1].to_s
      task_labels = task_labels + "|" + count[0]
    end
    chart_data.sub!(",", "")
    link = link + chart_data
    link = link + "&chxl=1:"
    link = link + task_labels
    link = link + "|0:"
    link = link + chart_labels
    link = link + "|2:|0|"
    link = link + @users.length.to_s
    link = link + "&chxt=x,x,y&chf=bg,s,000000"
    return link
  end

end
