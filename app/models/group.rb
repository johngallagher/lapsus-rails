class Group < ActiveRecord::Base
  attr_accessible :url, :entries

  has_many :entries  
end