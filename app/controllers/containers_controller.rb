class ContainersController < ApplicationController
  def new
    @container = Container.new(params.permit(:container))
    render :new
  end

  def create
    @container = Container.new(container_params)
    if @container.save
      Trainer.train
      flash[:alert] = @container.errors
      redirect_to projects_url
    else
      render :new
    end
  end

  def index
    @containers = Container.all
  end

  def destroy
    @container = Container.find(params.permit(:id)[:id])
    @container.destroy
    Trainer.train
    redirect_to containers_path
  end
  private
  def container_params
    params.require(:container).permit(:name, :url)
  end
end
