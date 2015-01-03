class Container < ActiveRecord::Base
  include Pathable
  validates_presence_of :path
  belongs_to :user

  scope :for_user, lambda { |user| where(user_id: user.id) }

  def self.possible_paths(user)
    user.entries.possible_paths - user.containers.path_heirarchies
  end

  def self.path_heirarchies
    all
      .map { |container| container.path_heirarchy }
      .flatten
      .uniq
  end

  def contains_project_for_entry?(entry)
    return false if entry_is_non_document?(entry)

    contains_entry?(entry) && entry_nested_within_project_folder?(entry)
  end

  def project_name_from_entry(entry)
    entry.path_components[path_depth]
  end

  def project_path_from_entry(entry)
    '/' + entry.path_components.take(path_depth + 1).join('/')
  end

  private
  def entry_is_non_document?(entry)
    URI(entry.url).scheme != 'file'
  end

  def entry_nested_within_project_folder?(entry)
    entry.path_components.length >= path_components.length + 2
  end

  def contains_entry?(entry)
    entry.path_components.take(path_components.length) == path_components
  end
end
