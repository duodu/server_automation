class CreateInstances < ActiveRecord::Migration
  def change
    create_table :instances do |t|
      t.integer :ip_id
      t.integer :port_id
      t.integer :account_id
      t.integer :need_delete
      t.integer :need_restart

      t.timestamps
    end
  end
end
