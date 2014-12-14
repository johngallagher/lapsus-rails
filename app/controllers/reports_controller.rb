class ReportsController < ApplicationController
  before_action :authenticate_user!

  def index
    todays_entries = Entry.for_user(current_user).where('started_at > ? and finished_at < ?', 1.days.ago, Time.now)
    grouped_entries = todays_entries.group_by(&:project_id)
    @report = grouped_entries.map do |project_id, entries|
      OpenStruct.new(name: entries.first.project_name, time: entries.map(&:duration).inject(&:+))
    end
  end
end
