class PublicController < ApplicationController

  #render first page
  #TODO if you're logged in, you shouldn't be able to access this page
  def index
    if logged_in? && !authorized?
      redirect_to("/task")
    elsif logged_in? && authorized?
      redirect_to("/admin")
    end
  end
  
  #render the info page
  def info
  end
  
  #render the help page
  def help
  end
  
end
