class Entry < ActiveRecord::Base
  attr_accessible :end, :project_id, :start

  belongs_to :project
end
