class Entry < ActiveRecord::Base
  include Pathable
  belongs_to :project
  before_save :calculate_duration

  validates_presence_of :started_at, :finished_at, :path

  scope :for_user, lambda { |user| where(user_id: user.id) }

  def overlapping_entries
    overlapping_start                = Entry.where('started_at < ? AND finished_at > ?', self.finished_at, self.finished_at)
    overlapping_end                  = Entry.where('finished_at > ? AND started_at < ?', self.started_at, self.started_at)
    inside                           = Entry.where('started_at > ? AND finished_at < ?', self.started_at, self.finished_at)
    exactly_overlapping_start_or_end = Entry.where('started_at = ? OR finished_at = ?', self.started_at, self.finished_at)
    (overlapping_start + overlapping_end + inside + exactly_overlapping_start_or_end)
      .reject {|entry| entry == self }
      .uniq
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
