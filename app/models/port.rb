class Port < ActiveRecord::Base
  attr_accessible :name
  has_many :instances, :dependent => :nullify
end
