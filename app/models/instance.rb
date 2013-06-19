class Instance < ActiveRecord::Base
  attr_accessible :destination, :ip, :need_delete, :need_restart, :password, :path, :port, :username
end
