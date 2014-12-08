module Pathable
  def path_depth
    path_components.count
  end
    
  def path_components
    Pathname.new(path).each_filename.to_a
  end

  def path
    URI(url).path
  end
end
