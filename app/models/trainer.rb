class Trainer
  SEARCH_WINDOW = 10
  def self.train_entry(entry, mode)
    entry.untrain
    no_project = entry.project

    Container.for_user(entry.user).each do |container|
      if container.contains_project_for_entry?(entry)
        entry.project = Project.find_or_create_from_container_and_entry(container, entry)
      end
    end

    if mode == :last_active && entry.project == no_project && entry.non_document? && entry.started_at
      previous_entry = Entry.for_user(entry.user).ascending.where('finished_at >= ?', entry.started_at - SEARCH_WINDOW).first
      if previous_entry && previous_entry.project != no_project && previous_entry != entry
        entry.project = previous_entry.project 
      end
    end

    entry.save
    Rails.logger.debug("Trained entry #{entry.inspect}")
    entry
  end

  def self.train_for(user, mode)
    Project.where(preset: false).delete_all

    Entry.for_user(user).ascending.each do |entry|
      train_entry(entry, mode)
    end
  end
end
