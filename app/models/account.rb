class Account < ActiveRecord::Base
  attr_accessible :password, :username
  has_many :instances, :dependent => :nullify
end
