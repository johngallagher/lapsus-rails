class Trainer
  def self.train_entry(entry)
    users_containers = Container.where(user_id: entry.user_id)
    users_containers.each do |container|
      if container.contains_project_for_entry?(entry)
        entry.project = Project.find_or_create_from_container_and_entry(container, entry)
        entry.save!
      end
    end
    entry
  end

  def self.train_for(user)
    Project.delete_all

    entries = Entry.for_user(user)
    untrain_entries(entries)

    Container.for_user(user).each do |container|
      entries.each do |entry|
        if container.contains_project_for_entry?(entry)
          entry.project = Project.find_or_create_from_container_and_entry(container, entry)
          entry.save!
        end
      end
    end
  end

  def self.untrain_entries(entries)
    entries.each { |entry| entry.project = nil; entry.save! }
  end
end
