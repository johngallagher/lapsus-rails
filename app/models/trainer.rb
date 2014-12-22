class Trainer
  def self.train_entry(entry, mode)
    entry.untrain
    no_project = entry.project

    Container.for_user(entry.user).each do |container|
      if container.contains_project_for_entry?(entry)
        entry.project = Project.find_or_create_from_container_and_entry(container, entry)
      end
    end

    adjust_project_for_last_active_mode(entry, no_project) if mode == :last_active

    entry.save
    Rails.logger.debug("Trained entry #{entry.inspect}")
    entry
  end

  def self.adjust_project_for_last_active_mode(entry, no_project)
    return if entry.project != no_project
    return if !entry.non_document?
    return if entry.started_at.nil?

    entry.project = entry.previous.project if entry.previous && entry.previous.project != no_project
  end

  def self.train_for(user, mode)
    Project.where(preset: false).delete_all

    Entry.for_user(user).ascending.each do |entry|
      train_entry(entry, mode)
    end
  end
end
