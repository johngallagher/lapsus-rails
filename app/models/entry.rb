class Entry < ActiveRecord::Base
  SEARCH_WINDOW = 10
  include Pathable
  belongs_to :project
  belongs_to :user

  before_save :calculate_duration

  validates_presence_of :started_at, :finished_at, :project
  validate :url_must_be_blank_or_valid, :no_overlapping_entries

  def self.split_into_hours(start, finish)
    grouped = [[ start, start.end_of_hour ]]

    boundary = start.end_of_hour + 1.hour
    while finish > boundary.end_of_hour
      grouped << [boundary.beginning_of_hour, boundary.end_of_hour]
      boundary += 1.hour
    end

    grouped << [finish.beginning_of_hour, finish]
    grouped
  end

  def self.new_split_by_hour(attrs)
    return [Entry.new(attrs)] if attrs.values_at(:started_at, :finished_at).any?(&:nil?)

    started_at = Time.zone.parse(attrs[:started_at])
    finished_at = Time.zone.parse(attrs[:finished_at])

    within_the_same_hour = finished_at < started_at.end_of_hour
    if within_the_same_hour
      [Entry.new(attrs)] 
    else
      split_into_hours(started_at, finished_at).map do |(partition_start, partition_end)|
        partition_attrs = attrs.merge({ started_at: partition_start, finished_at:  partition_end })
        Entry.new(partition_attrs)
      end
    end
  end

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
    from = range.begin.at_beginning_of_day
    to = (range.end + 1.day).at_beginning_of_day
    where('started_at >= ? and finished_at <= ?', from, to)
  end

  def self.possible_paths
    documents
      .map { |entry| entry.possible_paths }
      .flatten
      .uniq
  end

  def possible_paths
    possible_paths = path_heirarchy[0..-3]
    user.containers.map(&:path).each do |path|
      index_of_container_path = possible_paths.index(path)
      possible_paths.slice!(index_of_container_path..-1) if index_of_container_path
    end
    possible_paths
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
