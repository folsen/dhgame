class EpisodesController < ApplicationController
  before_filter :admin_required
  
  #render the page to create a new episode
  def new
    @episode = Episode.new() #to avoid nil errors when rendering the form
  end

  #render the edit page for the id given
  def edit
    @episode = Episode.find_by_id(params[:id])
  end

  #create and save the episode from the paramaters from the form
  def create
    @episode = Episode.new(params[:episode])
    if @episode.save
      flash[:notice] = "Episode #{@episode.name} was created!"
      redirect_to :controller => :admin, :action => :create
    else
      flash[:error] = "Episode could not be created!"
      redirect_to new_episode_path 
    end
  end
  
  #just update the episode, called from the edit page
  def update
    episode = Episode.find_by_id(params[:id])
    if episode.update_attributes(params[:episode])
      flash[:notice] = "Episode updated."
    else
      flash[:error] = "Could not update!"
    end
    redirect_to :controller => :admin, :action => :create 
  end

  #tries to delete an episode
  def destroy
    episode = Episode.find_by_id(params[:id])
    if episode.destroy
      flash[:notice] = "Episode deleted"
    else
      flash[:notice] = "Episode could not be deleted. Check the log!"
    end  
    redirect_to :controller => :admin, :action => :create 
  end
end
