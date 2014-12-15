class Report 
  include ActiveModel::Model
  attr_accessor :daterange, :entries
  #def self.model_name
    #'report'
  #end

  def projects
    grouped_entries.map do |project_id, entries|
      OpenStruct.new(name: entries.first.project_name, time: entries.map(&:duration).inject(&:+))
    end
  end

  def entries_in_range
    entries.where('started_at > ? and finished_at < ?', from, to)
  end

  def grouped_entries
    entries_in_range.group_by(&:project_id)
  end

  def from
    DateTime.parse(date_range.first).at_beginning_of_day
  end

  def to
    DateTime.parse(date_range.last).at_end_of_day
  end

  def date_range
    daterange.split(' - ')
  end
end
