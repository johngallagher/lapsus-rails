class Entry < ActiveRecord::Base
  include Pathable
  belongs_to :project
  before_save :calculate_duration

  validates_presence_of :started_at, :finished_at, :url
  validates_format_of :url, with: URI.regexp
  #validate :cannot_overlap_another_entry

  scope :untrained, -> { where(project: nil) }

  #def cannot_overlap_another_entry

  #end

  def overlapping_entries
    overlapping_start                = Entry.where('started_at < ? AND finished_at > ?', self.finished_at, self.finished_at)
    overlapping_end                  = Entry.where('finished_at > ? AND started_at < ?', self.started_at, self.started_at)
    inside                           = Entry.where('started_at > ? AND finished_at < ?', self.started_at, self.finished_at)
    exactly_overlapping_start_or_end = Entry.where('started_at = ? OR finished_at = ?', self.started_at, self.finished_at)
    (overlapping_start + overlapping_end + inside + exactly_overlapping_start_or_end)
      .reject {|entry| entry == self }
      .uniq
  end

  def possible_container_urls
    urls_from_entry = []
    Pathname.new(url).descend { |path| urls_from_entry << path.to_s }
    urls_from_entry[1..-3]
  end

  def project_name
    return 'None' if project.nil?

    project.name
  end

  private
  def calculate_duration
    self.duration = self.finished_at - self.started_at
  end
end
