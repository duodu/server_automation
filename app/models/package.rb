class Package < ActiveRecord::Base
  attr_accessible :instance_id, :package_array, :path_id, :sort
  belongs_to :instance
  belongs_to :path
end
