class Entry < ActiveRecord::Base
  belongs_to :project

  def path_depth
    path_components.count
  end
    
  def path_components
    Pathname.new(url).each_filename.to_a
  end
end
