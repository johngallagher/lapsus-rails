class TimelineReport 
  include ActiveModel::Model
  attr_accessor :range, :user

  def run
    report = []
    user
      .entries
      .within_range(range_as_dates)
      .includes(:project)
      .group_by(&:project)
      .each do |(project, entries)|
      entries.each do |entry|
        report << [project.name, entry.started_at, entry.finished_at]
      end
    end
    report
  end

  def range
    @range || Time.current.strftime('%d-%m-%Y - %d-%m-%Y')
  end

  def range_as_dates
    dates_from_range = range.split(' - ').map { |date| Time.zone.parse(date) }
    Range.new(*dates_from_range)
  end
end

