class Entry < ActiveRecord::Base
  include Pathable
  belongs_to :project
end
