class Path < ActiveRecord::Base
  attr_accessible :name
  has_many :packages, :dependent => :nullify
end
