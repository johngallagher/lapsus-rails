class Trainer
  def self.train
    Project.delete_all
    Entry.all.each { |entry| entry.project = nil; entry.save! }
    Container.all.each do |container|
      Entry.all.each do |entry|
        if container.contains_project_for_entry?(entry)
          entry.project = Project.find_or_create_from_container_and_entry(container, entry)
        end
        entry.save!
      end
    end
  end
end
