class ContainersController < ApplicationController
  def new
    @container = Container.new(container_params)
    render :new
  end

  def create
    @container = Container.new(container_params)
    if @container.save
      redirect_to entries_url
    else
      render :new
    end
  end

  def edit
  end

  def update
  end

  def delete
  end

  def destroy
  end

  private
  def container_params
    params.permit(:name, :url)
  end
end
