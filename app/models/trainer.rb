class Trainer
  def self.train
    Container.all.each do |container|
      Entry.all.each do |entry|
        if container.contains_project_for_entry?(entry)
          entry.project = Project.find_or_create_from_container_and_entry(container, entry)
        else
          entry.project = nil
        end
        entry.save!
      end
    end
  end
end
