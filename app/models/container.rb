class Container < ActiveRecord::Base
  include Pathable
  validates_presence_of :path

  def self.possible_paths
    from_entries = Entry.all.map { |entry| possible_paths_for(entry) }.flatten.uniq
    from_containers = Container.all.map { |container| container.path_heirarchy }.flatten.uniq
    from_entries - from_containers
  end

  def self.possible_paths_for(entry)
    possible_paths = entry.path_heirarchy[0..-3]
    Container.all.map(&:path).each do |path|
      index_of_container_path = possible_paths.index(path)
      possible_paths.slice!(index_of_container_path..-1) if index_of_container_path
    end
    possible_paths
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
