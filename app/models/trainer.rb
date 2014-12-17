class Trainer
  def self.train_entry(entry)
    Container.for_user(entry.user).each do |container|
      if container.contains_project_for_entry?(entry)
        entry.project = Project.find_or_create_from_container_and_entry(container, entry)
      else
        entry.project = Project.find_by(preset: true)
      end
    end
    entry.save!
    entry
  end

  def self.train_for(user)
    Project.where(preset: false).delete_all

    Entry.for_user(user).each do |entry|
      train_entry(entry)
    end
  end

  def self.untrain_entries(entries)
    entries.each { |entry| entry.project = nil; entry.save! }
  end
end
