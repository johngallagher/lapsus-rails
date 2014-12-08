class Entry < ActiveRecord::Base
  include Pathable
  belongs_to :project

  validates_presence_of :started_at, :finished_at, :url
  validates_format_of :url, with: URI.regexp

  scope :untrained, -> { where(project: nil) }

  def possible_container_urls
    urls_from_entry = []
    Pathname.new(url).descend { |path| urls_from_entry << path.to_s }
    urls_from_entry[0..-3]
  end
end
