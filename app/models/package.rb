class Package < ActiveRecord::Base
  attr_accessible :ip, :package_array, :path_id, :sort, :username
  belongs_to :path
  validates :ip, :package_array, :sort, :username, :presence => true
end
