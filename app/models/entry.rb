class Entry < ActiveRecord::Base
  belongs_to :project

  def self.create_with_project(attrs)
    path_components = new(attrs).path_components

    containers = Container.all

    containers.each do |container|
      if path_components.length >= container.path_components.length + 2 &&
          path_components.take(container.path_components.length) == container.path_components

        project_url = File.join(['/'], path_components.take(container.path_components.count + 1))
        project_for_entry = Project.find_or_create_by(url: project_url) do |project|
          project.name = path_components[container.path_components.count]
        end
        attrs[:project_id] = project_for_entry.id
      end
    end

    create(attrs)
  end

  def path_components
    Pathname.new(url).each_filename.to_a
  end
end
