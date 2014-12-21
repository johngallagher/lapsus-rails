class Entry < ActiveRecord::Base
  include Pathable
  belongs_to :project
  belongs_to :user
  before_save :calculate_duration

  validates_presence_of :started_at, :finished_at
  validate :url_must_be_blank_or_valid

  scope :ascending, lambda { order('started_at ASC') }
  scope :for_user, lambda { |user| where(user_id: user.id) }

  def url_must_be_blank_or_valid
    if url && url.present? 
      self.errors.add(:url, 'must be valid') if url !~ URI.regexp
      URI.parse(url)
    end
  rescue URI::InvalidURIError => e
    self.errors.add(:url, "must be valid: #{e.message}")
  end
  
  def untrain
    self.project = Project.none_for_user(self.user)
  end

  def non_document?
    URI(self.url).scheme != 'file'
  end

  def overlapping_entries
    overlapping = Entry.where('(started_at < ? AND finished_at > ?) OR (finished_at > ? AND started_at < ?) OR (started_at > ? AND finished_at < ?) OR (started_at = ? OR finished_at = ?)', self.started_at, self.finished_at, self.started_at, self.finished_at, self.started_at, self.finished_at, self.started_at, self.finished_at)
    overlapping.reject {|entry| entry == self }.uniq
  end

  def path
    if self.url
      URI(self.url).path
    else
      ''
    end
  end

  private
  def calculate_duration
    self.duration = self.finished_at - self.started_at
  end
end
