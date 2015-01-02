class ReportsController < ApplicationController
  before_action :authenticate_user!

  def index
    @report = Report.new(report_params)

    render :index
  end

  private
  def report_params
    params.fetch(:report, {}).permit(:range).merge({ user: current_user })
  end
end
