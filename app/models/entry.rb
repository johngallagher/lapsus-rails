class Entry < ActiveRecord::Base
  attr_accessible :end, :project_id, :start, :url, :trained

  belongs_to :project
  belongs_to :group
end
