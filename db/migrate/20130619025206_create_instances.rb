class CreateInstances < ActiveRecord::Migration
  def change
    create_table :instances do |t|
      t.string :ip
      t.integer :port
      t.string :username
      t.string :password
      t.integer :need_delete
      t.integer :need_restart
      t.string :destination
      t.string :path

      t.timestamps
    end
  end
end
