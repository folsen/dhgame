module ApplicationHelper
  
  #return a home link based on what kind of user you are
  #TODO this doesnt look good, fix it somehow
  def home_link
    if current_user && !current_user.admin
      return link_to("Home", :controller => :task, :action => :index)
    elsif current_user && current_user.admin
      return link_to("Home", :controller => :admin, :action => :index)
    else
      return link_to("Home", :controller => :public, :action => :index)
    end
  end
  
  #return a linked image at the top that sends you to the correct index page
  #TODO refactor - each index action should redirect you to where you are supposed to be
  def image_button_link
    if current_user && current_user.admin != 1
      return link_to( image_tag("/images/dhg-button.png", :id => "dhg-button"), 
        :controller => :task, :action => :index )
    elsif current_user && current_user.admin == 1
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
  #TODO change to fit with paperclip
  def partial_path(task_object)
    path = "task/partials/task_#{task_object.partial}"
    #logger.info(path)
    return path
  end
  
end
