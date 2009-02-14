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
  
end
