class Api::V1::EntriesController < ApplicationController
  doorkeeper_for :all
  respond_to :json

  def create
    entries = params[:entries].map { |attrs| Entry.new_split_by_hour(entry_attrs(attrs)) }.flatten

    trained_entries = trained(entries)
    if invalid(trained_entries).empty?
      render json: trained_entries.to_json, status: :created
    else
      render json: invalid(trained_entries).map { |entry| { entry: entry, errors: entry.errors.full_messages } }.to_json, status: :unprocessable_entity
    end
  end

  def invalid(entries)
    entries.select { |entry| entry.invalid? }
  end

  def trained(entries)
    entries.each do |entry|
      Trainer.train_entry(entry, :last_active)
      entry
    end
  end

  def current_resource_owner_id
    doorkeeper_token.resource_owner_id
  end

  def entry_attrs(attrs)
    attrs
      .permit(:started_at, :finished_at, :url, :application_bundle_id, :application_name)
      .merge(user_id: current_resource_owner_id)
  end
end
