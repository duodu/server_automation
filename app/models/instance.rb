class Instance < ActiveRecord::Base
  attr_accessible :account_id, :ip_id, :need_delete, :need_restart, :port_id
  belongs_to :ip
  belongs_to :port
  belongs_to :account
end
