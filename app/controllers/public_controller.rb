class PublicController < ApplicationController

  #render first page
  def index
    if logged_in? && !authorized?
      redirect_to(tasks_path)
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
