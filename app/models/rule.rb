class Rule < ActiveRecord::Base
    attr_accessible :url, :project
    validates_presence_of :url
    validates_uniqueness_of :url

    belongs_to :project
end