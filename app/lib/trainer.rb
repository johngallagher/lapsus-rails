class Trainer
  def initialize(entry, project)
    @entry = entry
    @project = project
  end

  def train
    remove_conflicts
    create_rule
    train_entry
  end

  private

  def create_rule
    rule = Rule.where(url: @entry.url).first_or_create
    rule.project = @project
    rule.save
  end

  def train_entry
    @entry.project = @project
    @entry.trained = true
    @entry.save
  end

  def remove_conflicts
    Rule.where(url: ancestors).destroy_all
  end

  def ancestors
    ancestors = []
    Pathname.new(@entry.url).ascend { |p| ancestors << p.to_s }
    ancestors    
  end
end