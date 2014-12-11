class EntriesController < ApplicationController
  before_action :authenticate_user!
  def index
    @entries = Entry.all
  end
end
