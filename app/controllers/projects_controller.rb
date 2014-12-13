class ProjectsController < ApplicationController
  before_action :authenticate_user!
  def index
    @projects = Project.for_user(current_user)
  end
end
