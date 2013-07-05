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
    Rule.create(url: @entry.url)
  end

  def train_entry
    @entry.project = @project
    @entry.trained = true
    @entry.save
  end
end