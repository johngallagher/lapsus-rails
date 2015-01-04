class TimelineReport < Value.new(:user)
  def run
    report = []
    user.entries.includes(:project).group_by(&:project).each do |(project, entries)|
      entries.each do |entry|
        report << [project.name, entry.started_at, entry.finished_at]
      end
    end
    report
  end
end

