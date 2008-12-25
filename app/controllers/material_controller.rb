class MaterialController < ApplicationController
  def destroy
    material = Material.find(params[:id])
    task_id = material.task_id
    material.destroy
    redirect_to("/admin/show/#{task_id}")
  end
  
  def create
    @material = Material.new(params[:material])
    if @material.save
      redirect_to("/admin/show/#{@material.task_id}")
    else
      flash[:error] = "Couldn't upload file"
      redirect_to("/admin/show")
    end
  end
end
