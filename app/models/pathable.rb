module Pathable
  def path_depth
    path_components.count
  end
    
  def path_components
    filenames = Pathname.new(path).each_filename.to_a
    filenames << '' if path.ends_with?('/')
    filenames
  end

  def path_heirarchy
    paths = []
    Pathname.new(path).descend { |p| paths << p.to_s }
    paths.reject(&:empty?).reject { |p| p == '/' }
  end
end
