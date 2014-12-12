class Container < ActiveRecord::Base
  include Pathable
  validates_presence_of :path

  def self.possible_paths
    possible_paths = []
    Entry.untrained.each do |entry|
      possible_paths << entry.possible_container_paths
    end
    possible_paths.flatten.uniq
  end

  def contains_project_for_entry?(entry)
    contains_entry?(entry) && entry_nested_within_project_folder?(entry)
  end

  def project_name_from_entry(entry)
    entry.path_components[path_depth]
  end

  def project_path_from_entry(entry)
    '/' + entry.path_components.take(path_depth + 1).join('/')
  end

  private
  def entry_nested_within_project_folder?(entry)
    entry.path_components.length >= path_components.length + 2
  end

  def contains_entry?(entry)
    entry.path_components.take(path_components.length) == path_components
  end
end
