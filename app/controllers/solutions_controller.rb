class SolutionsController < ApplicationController
  def index
    @solutions = Solution.find(:all, :order => "created_at DESC")
  end

  def new
    @solution = Solution.new
  end

  def create
    solution = Solution.new(params[:solution])
    if solution.save
      flash[:notice] = "Uploaded solution successfully."
    else
      flash[:error] = "Something went wrong"
    end
    redirect_to :action => "index"
  end

  def edit
    @solution = Solution.find_by_id(params[:id])
  end

  def update
    @solution = Solution.find(params[:id])
    @solution.update_attributes(params[:solution])
    if @solution.errors.empty?
      flash[:notice] = "Your changes are saved"
      redirect_to :action => "index"
    else
      flash[:error] = "Couldn't do the changes :("
      render :action => "edit"
    end
  end

  def destroy
    solution = Solution.find_by_id(params[:id])
    if !solution.nil?
      solution.destroy
      flash[:notice] = "Solution PDF removed."
    end
    redirect_to :action => "index"
  end

end
