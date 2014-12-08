class Container < ActiveRecord::Base
  include Pathable

  def self.possible_urls
    possible_urls = []
    Pathname.new(Entry.first.url).descend { |path| possible_urls << path.to_s }
    possible_urls[0..-3]
  end

  def contains_project_for_entry?(entry)
    contains_entry?(entry) && entry_nested_within_project_folder?(entry)
  end

  def project_name_from_entry(entry)
    entry.path_components[path_depth]
  end

  def project_url_from_entry(entry)
    File.join(['/'], entry.path_components.take(path_depth + 1))
  end

  private
  def entry_nested_within_project_folder?(entry)
    entry.path_components.length >= path_components.length + 2
  end

  def contains_entry?(entry)
    entry.path_components.take(path_components.length) == path_components
  end
end
