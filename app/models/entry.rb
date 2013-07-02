class Entry < ActiveRecord::Base
  attr_accessible :end, :project_id, :start, :url

  belongs_to :project
end
