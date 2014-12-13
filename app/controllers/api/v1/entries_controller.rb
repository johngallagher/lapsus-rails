class Api::V1::EntriesController < ApplicationController
  doorkeeper_for :all
  respond_to :json

  def create
    new_entries = params[:entries].map do |entry|
      Entry.new(entry.permit(:started_at, :finished_at, :path).merge(user_id: current_resource_owner_id))
    end

    invalid_entries = new_entries.select { |entry| entry.invalid? }
    if invalid_entries.empty?
      created_entries = new_entries.each { |entry| entry.save }
      Trainer.train_for(current_resource_owner)
      render json: created_entries.to_json, status: :created
    else
      render json: invalid_entries.map { |entry| { entry: entry, errors: entry.errors.full_messages } }.to_json, status: :unprocessable_entity
    end
  end

  def current_resource_owner
    User.find(current_resource_owner_id) if doorkeeper_token
  end

  def current_resource_owner_id
    doorkeeper_token.resource_owner_id
  end
end
