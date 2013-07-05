class Trainer
  def initialize(entry, project)
    @entry = entry
    @project = project
  end

  def train
    Rule.create(url: @entry.url)
    @entry.project = @project
    @entry.trained = true
    @entry.save
  end
end