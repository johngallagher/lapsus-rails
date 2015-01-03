class ProjectsController < ApplicationController
  before_action :authenticate_user!

  def index
    @container = Container.new
    @container_paths = current_user.possible_container_paths
    @containers = current_user.containers
    @projects = current_user.projects
  end
end
