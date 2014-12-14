class Api::V1::EntriesController < ApplicationController
  doorkeeper_for :all
  respond_to :json

  def create
    entries = params[:entries].map do |entry|
      Entry.new(entry.permit(:started_at, :finished_at, :path).merge(user_id: current_resource_owner_id))
    end

    if invalid(entries).empty?
      render json: trained(entries).to_json, status: :created
    else
      render json: invalid(entries).map { |entry| { entry: entry, errors: entry.errors.full_messages } }.to_json, status: :unprocessable_entity
    end
  end

  def invalid(entries)
    entries.select { |entry| entry.invalid? }
  end

  def trained(entries)
    entries.each { |entry| Trainer.train_entry(entry) }
  end

  def current_resource_owner
    User.find(current_resource_owner_id) if doorkeeper_token
  end

  def current_resource_owner_id
    doorkeeper_token.resource_owner_id
  end
end
