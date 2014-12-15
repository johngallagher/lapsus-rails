class ReportsController < ApplicationController
  before_action :authenticate_user!

  def index
    @report = Report.new(daterange: report_params[:daterange], entries: Entry.for_user(current_user))
    @entries = @report.entries_in_range.group_by(&:project_id).inject({}) { |memo, (pid, e)|
      memo.merge({ e.first.project_name => (e.map(&:duration).inject(&:+) / 60) })
    }

    render :index
  end

  private
  def report_params
    set_default_range
    params.require(:report).permit(:daterange)
  end

  def set_default_range
    params[:report] = default_range if params[:report].nil? || params[:report][:daterange].nil?
  end

  def default_range
    today = Time.now.strftime('%d-%m-%Y') 
    { daterange: "#{today} - #{today}" }
  end
end
