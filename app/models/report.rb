require 'active_support/core_ext/date_time/calculations'

class Report
  include ActiveModel::Model
  attr_accessor :range, :user

  def run
    Entry
      .for_user(user)
      .where('started_at > ? and finished_at < ?', from, to)
      .group(:project_id)
      .sum(:duration)
      .inject({}) do |memo, (project_id, seconds)|
        hours = (seconds.to_f / 3600).round(2)
        project_name = Project.find(project_id).name
        memo.merge({ project_name => hours })
      end
  end

  def run_time_grouped
    if over_one_day?
      run_hour_grouped
    else
      run_day_grouped
    end
  end

  def run_hour_grouped
    result = Entry
      .for_user(user)
      .where('started_at > ? and finished_at < ?', from, to)
      .group(:project_id)
      .group_by_hour(:started_at, format: "%01H:00")
      .sum(:duration)
      .inject({}) do |memo, ((project_id, time_label), seconds)|
        minutes = (seconds.to_f / 60).round(2)
        project_name = Project.find(project_id).name
        memo.merge({[project_name, time_label] => minutes})
      end
    result
  end

  def run_day_grouped
    result = Entry
      .for_user(user)
      .where('started_at > ? and finished_at < ?', from, to)
      .group(:project_id)
      .group_by_day(:started_at, format: "%d-%m")
      .sum(:duration)
      .inject({}) do |memo, ((project_id, time_label), seconds)|
        hours = (seconds.to_f / 3600).round(2)
        project_name = Project.find(project_id).name
        memo.merge({[project_name, time_label] =>hours })
      end
    result
  end

  def format_string
    over_one_day? ? '#m' : '#h'
  end

  private
  def over_one_day?
    range_as_dates.to_a.size == 1
  end

  def from
    range_as_dates.begin.at_beginning_of_day.to_s(:db)
  end

  def to
    range_as_dates.end.at_end_of_day.to_s(:db)
  end

  def range_as_dates
    dates_from_range = range.split(' - ').map { |date| DateTime.parse(date) }
    Range.new(*dates_from_range)
  end

  def range
    @range || Time.now.strftime('%d-%m-%Y - %d-%m-%Y')
  end
end
