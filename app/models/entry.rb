class Entry < ActiveRecord::Base
  belongs_to :project

  def self.create_with_project(attrs)
    entry = new(attrs)

    Container.all.each do |container|
      if container.contains_project_for_entry?(entry)
        attrs[:project_id] = Project.find_or_create_from_container_and_entry(container, entry).id
      end
    end

    create(attrs)
  end


  def path_depth
    path_components.count
  end
    
  def path_components
    Pathname.new(url).each_filename.to_a
  end
end
