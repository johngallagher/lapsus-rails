class Container < ActiveRecord::Base
  include Pathable
  validates_presence_of :url
  validates_format_of :url, with: URI.regexp

  def self.possible_urls
    possible_urls = []
    Entry.untrained.each do |entry|
      possible_urls << entry.possible_container_urls
    end
    possible_urls.flatten.uniq
  end

  def contains_project_for_entry?(entry)
    contains_entry?(entry) && entry_nested_within_project_folder?(entry)
  end

  def project_name_from_entry(entry)
    entry.path_components[path_depth]
  end

  def project_url_from_entry(entry)
    project_path = entry.path_components.take(path_depth + 1).join('/')
    URI::Generic.build(scheme: 'file', path: "///#{project_path}").to_s
  end

  private
  def entry_nested_within_project_folder?(entry)
    entry.path_components.length >= path_components.length + 2
  end

  def contains_entry?(entry)
    entry.path_components.take(path_components.length) == path_components
  end
end
