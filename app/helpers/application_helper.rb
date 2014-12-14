module ApplicationHelper
  def alert_class(type)
    if type.to_sym == :alert
      'alert-warning'
    elsif type.to_sym == :notice
      'alert-info'
    elsif type.to_sym == :error
      'alert-danger'
    end
  end
end
