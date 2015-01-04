class EntriesController < ApplicationController
  before_action :authenticate_user!

  def index
    @timeline_report = TimelineReport.new(report_params)
    @entries = current_user.entries.within_range(@timeline_report.range_as_dates)
  end

  private
  def report_params
    params.fetch(:timeline_report, {}).permit(:range).merge({ user: current_user })
  end
end
