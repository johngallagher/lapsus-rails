class ProjectsController < ApplicationController
  before_action :authenticate_user!

  def index
    @container = Container.new
    @container_paths = Container.possible_paths(current_user)
    @containers = Container.for_user(current_user)
    @projects = Project.for_user(current_user)
  end
end
