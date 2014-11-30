class Container < ActiveRecord::Base
  def path_components
    Pathname.new(url).each_filename.to_a
  end
end
