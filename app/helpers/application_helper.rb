module ApplicationHelper
  def alert_class(type)
    if type.to_sym == :alert
      'alert-warning'
    elsif type.to_sym == :error
      'alert-danger'
    else
      'alert-info'
    end
  end

  def as_hours_and_minutes_and_seconds(total_seconds)
    seconds = total_seconds % 60
    minutes = (total_seconds / 60) % 60
    hours = total_seconds / (60 * 60)
    format('%d:%02d:%02d', hours, minutes, seconds)
  end

  def as_hours_and_minutes(total_seconds)
    minutes = (total_seconds / 60) % 60
    hours = total_seconds / (60 * 60)
    format('%d:%02d', hours, minutes)
  end
end
