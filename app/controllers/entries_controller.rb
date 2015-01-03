class EntriesController < ApplicationController
  before_action :authenticate_user!

  def index
    @entries = current_user.entries.includes(:project).descending.limit(100)
  end
end
