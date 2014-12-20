class Trainer
  def self.train_entry(entry, mode)
    entry.untrain

    Container.for_user(entry.user).each do |container|
      if container.contains_project_for_entry?(entry)
        entry.project = Project.find_or_create_from_container_and_entry(container, entry)
      elsif mode == :last_active
        previous_entry = Entry.where('finished_at <= ?', entry.started_at).order('finished_at DESC').limit(1).first
        entry.project = previous_entry.project if previous_entry
      end
    end

    entry.save!
    entry
  end

  def self.train_for(user, mode)
    Project.where(preset: false).delete_all

    Entry.for_user(user).each do |entry|
      train_entry(entry, mode)
    end
  end
end
