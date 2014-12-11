class Api::EntriesController < ApplicationController
  respond_to :json

  def create
    entries = params[:entries]
    created_entries = entries.map do |entry|
      Entry.create(entry.permit(:started_at, :finished_at, :url))
    end
    Trainer.train
    render json: created_entries.to_json
  end
end
