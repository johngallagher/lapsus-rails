class Trainer
  def initialize(entry, project)
    @entry = entry
    @project = project
  end

  def train
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
end