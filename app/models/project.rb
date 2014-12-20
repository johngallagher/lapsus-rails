class Project < ActiveRecord::Base
  has_many :entries
  scope :for_user, lambda { |user| where(user_id: user.id) }
  scope :preset, lambda { where(preset: true) }

  def self.create_none_for_user!(user)
    Project.create!(name: 'None', preset: true, user_id: user.id, path: '')
  end

  def self.none_for_user(user)
    Project.for_user(user).preset.first
  end

  def self.find_or_create_from_container_and_entry(container, entry)
    find_or_create_by(path: container.project_path_from_entry(entry), preset: false) do |project|
      project.name = container.project_name_from_entry(entry)
      project.user_id = container.user_id
    end
  end
end
