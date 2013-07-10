class Trainer
  def initialize(entry, project)
    @entry = entry
    @project = project
  end

  def train
    destroy_conflicting_rules
    remember_rule
    train_entry
  end

  private

  def remember_rule
    rule = Rule.where(url: @entry.url).first_or_create
    rule.project = @project
    rule.save
  end

  def train_entry
    @entry.project = @project
    @entry.trained = true
    @entry.save
  end

  def destroy_conflicting_rules
    parent_url = Pathname.new(@entry.url).parent.to_s
    conflicting_rules = Rule.where(url: parent_url)
    if conflicting_rules.any?
      conflicting_rules.destroy_all
      Rails.logger.warn("Conflicting rules detected - destroying.")
    end
  end
end