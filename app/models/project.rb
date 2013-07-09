class Project < ActiveRecord::Base
  attr_accessible :name
  has_many :entries
  has_many :rules
end