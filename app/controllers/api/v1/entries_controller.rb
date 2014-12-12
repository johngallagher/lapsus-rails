class Api::V1::EntriesController < ApplicationController
  respond_to :json

  def create
    new_entries = entry_params.map { |attrs| Entry.new(attrs) }

    invalid_entries = new_entries.select { |entry| entry.invalid? }
    if invalid_entries.empty?
      created_entries = new_entries.each { |entry| entry.save }
      Trainer.train
      render json: created_entries.to_json, status: :created
    else
      render json: invalid_entries.map { |entry| { entry: entry, errors: entry.errors.full_messages } }.to_json, status: :unprocessable_entity
    end
  end

  private
  def entry_params
    params[:entries].map { |entry| entry.permit(:started_at, :finished_at, :path) }
  end
end