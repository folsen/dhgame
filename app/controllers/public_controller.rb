class PublicController < ApplicationController
  
  #render empty layout first page
  def index
  end
  
  # TODO refactor these three methods below into one
  
  #render the home partial
  def home
    render :partial => "home", :layout => false
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
