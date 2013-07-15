class Group < ActiveRecord::Base
  attr_accessor :url

  has_many :entries  
end