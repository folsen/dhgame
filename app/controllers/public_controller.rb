class PublicController < ApplicationController
  
  #render empty layout first page
  def index
    render :controller => "tasks", :action => "index" and return
  end
  
  # TODO refactor these three methods below into one
  
  #render the home partial
  def home
    if logged_in?
      render :partial => "tasks/index" and return
    end
    render :partial => "home", :layout => false and return
  end
  
  #render the info page
  def info
    render :partial => "info", :layout => false
  end
  
  #render the help page
  def help
    render :partial => "help", :layout => false
  end
  
end
