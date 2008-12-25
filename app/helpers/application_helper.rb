# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  #TODO Refactor to not use repetition, break down "options" into just the things to give
  #TODO text should be "<i>Click here to edit</i>" if it is empty or nil
  def editable_content(options)
    options[:content] = { :element => 'span' }.merge(options[:content])
    options[:url] = {}.merge(options[:url])
    options[:ajax] = { :okText => "'Save'", :cancelText => "'Cancel'"}.merge(options[:ajax] || {})
    script = Array.new
    script << "new Ajax.InPlaceEditor("
    script << "  '#{options[:content][:options][:id]}',"
    script << "  '#{url_for(options[:url])}',"
    script << "  {"
    script << options[:ajax].map{ |key, value| "#{key.to_s}: #{value}" }.join(", ")
    script << "  }"
    script << ")"

    content_tag(
      options[:content][:element],
      options[:content][:text],
      options[:content][:options]
    ) + javascript_tag( script.join("\n") )
  end
  
  #this is used to make a select menu for the episode headstart counts
  def select_with_integer_options (object, column, start, stop, default = nil)  
    output = "<select id=\"#{object}_#{column}\" name=\"#{object}[#{column}]\">"  
    for i in start..stop  
      output << "\n<option value=\"#{i}\""  
      output << " selected=\"selected\"" if i == default  
      output << ">#{i}"  
    end  
    output + "</select>"  
  end
  
  #return a home link based on what kind of user you are
  #TODO this doesnt look good, fix it somehow
  def home_link
    if User.active_user && User.active_user.admin != 1
      return link_to("Home", :controller => :task, :action => :index)
    elsif User.active_user && User.active_user.admin == 1
      return link_to("Home", :controller => :admin, :action => :index)
    else
      return link_to("Home", :controller => :public, :action => :index)
    end
  end
  
  #return a linked image at the top that sends you to the correct index page
  #TODO refactor - each index action should redirect you to where you are supposed to be
  def image_button_link
    if User.active_user && User.active_user.admin != 1
      return link_to( image_tag("/images/dhg-button.png", :id => "dhg-button"), 
        :controller => :task, :action => :index )
    elsif User.active_user && User.active_user.admin == 1
      return link_to( image_tag("/images/dhg-button.png", :id => "dhg-button"), 
        :controller => :admin, :action => :index)
    else
      return link_to( image_tag("/images/dhg-button.png", :id => "dhg-button"), 
        :controller => :public, :action => :index)
    end
  end
  
  #return a link to the info
  def info_link
    return link_to("Rules & Info", :controller => :public, :action => :info)
  end
    
  #return a link to the help
  def help_link
    return link_to("Help", :controller => :public, :action => :help)
  end
  
  #return the path for the task partial
  def partial_path(task_object)
    path = "task/partials/task_#{task_object.partial}"
    #logger.info(path)
    return path
  end
  
  #returns a formatted string of a difference between two times
  #params: the two times to be compared, given in float
  def time_difference(this_time, previous_time)
    return "#{((this_time - previous_time) / 60 / 60).to_i}h 
    #{((this_time - previous_time) / 60 % 60).to_i}m 
    #{((this_time - previous_time) % 60 % 60).to_i}s"
  end
  
end
