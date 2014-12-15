require 'active_support/core_ext/date_time/calculations'

class Report
  include ActiveModel::Model
  attr_accessor :range, :user

  def run
    results = ActiveRecord::Base.connection.exec_query(query).rows
    results.inject({}) { |memo, result| memo.merge(Hash[*result]) }
  end

  private
  def query
    "select projects.name as project, SUM(entries.duration) as time
            from entries
            inner join projects on entries.`project_id` = projects.`id`
            where entries.started_at > '#{from}' and entries.finished_at < '#{to}' and entries.user_id = #{user.id}
            group by project_id;"
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
