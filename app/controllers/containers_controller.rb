class ContainersController < ApplicationController
  before_action :authenticate_user!
  def create
    @container = Container.new(container_params)
    @container.user_id = current_user.id
    if @container.save
      Trainer.train_for(current_user, :last_active)
      redirect_to projects_path
    else
      flash.now[:alert] = @container.errors.full_messages.join(', ')
      render :new
    end
  end

  def destroy
    container = Container.for_user(current_user).find(params.permit(:id)[:id])
    container.destroy
    Trainer.train_for(current_user, :last_active)
    redirect_to projects_path
  end

  private
  def container_params
    params.require(:container).permit(:name, :path)
  end
end
