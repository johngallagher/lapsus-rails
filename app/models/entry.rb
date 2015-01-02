class Entry < ActiveRecord::Base
  SEARCH_WINDOW = 10
  include Pathable
  belongs_to :project
  belongs_to :user

  before_save :calculate_duration

  validates_presence_of :started_at, :finished_at, :project
  validate :url_must_be_blank_or_valid, :no_overlapping_entries

  def self.ascending
    order('started_at ASC')
  end

  def self.descending
    order('started_at DESC')
  end

  def self.for_user(user)
    where(user_id: user.id)
  end

  def self.documents
    where('url LIKE ?', "file:/%")
  end

  def self.within_range(range)
    from = range.begin.at_beginning_of_day.to_s(:db)
    to = range.end.at_end_of_day.to_s(:db)
    where('started_at > ? and finished_at < ?', from, to)
  end

  def no_overlapping_entries
    return if !started_at_changed? && !finished_at_changed?

    if overlapping_entries.any?
      self.errors.add('started_at and finished_at', 'overlap other entries')
    end
  end

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

  def previous
    Entry
      .for_user(self.user)
      .descending
      .where.not(id: self.id)
      .where('finished_at >= ? AND finished_at <= ?', self.started_at - SEARCH_WINDOW, self.started_at)
      .first
  end

  def non_document?
    return true if self.url.nil?

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

  def set_default_project
    untrain if self.project.nil?
  end
end
