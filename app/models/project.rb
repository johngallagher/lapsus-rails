class Project < ActiveRecord::Base
  has_many :entries

  def self.find_or_create_from_container_and_entry(container, entry)
    find_or_create_by(url: container.project_url_from_entry(entry)) do |project|
      project.name = container.project_name_from_entry(entry)
    end
  end
end
