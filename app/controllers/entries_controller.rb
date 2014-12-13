class EntriesController < ApplicationController
  before_action :authenticate_user!
  def index
    @entries = Entry.for_user(current_user)
  end
end
