class Entry < ActiveRecord::Base
  belongs_to :project

  def self.create_with_project(attrs)
    entry = Entry.create(attrs)

    Container.all.each do |container|
      if container.contains_project_for_entry?(entry)
        entry.project = Project.find_or_create_from_container_and_entry(container, entry)
        entry.save!
      end
    end
    entry
  end


  def path_depth
    path_components.count
  end
    
  def path_components
    Pathname.new(url).each_filename.to_a
  end
end
