class Rule < ActiveRecord::Base
    attr_accessible :url
    validates_presence_of :url
    validates_uniqueness_of :url
end