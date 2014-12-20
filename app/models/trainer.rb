class Trainer
  def self.train_entry(entry, mode)
    none = Project.none_for_user(entry.user)
    entry.project = none
    Container.for_user(entry.user).each do |container|
      if container.contains_project_for_entry?(entry)
        entry.project = Project.find_or_create_from_container_and_entry(container, entry)
      elsif mode == :normal
        entry.project = none
      elsif mode == :last_active
        previous_entry = Entry.where('finished_at <= ? AND project_id != ?', entry.started_at, none).order('finished_at DESC').limit(1).first
        if previous_entry
          entry.project = previous_entry.project
        else
          entry.project = none
        end
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
