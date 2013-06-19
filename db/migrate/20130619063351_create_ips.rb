class CreateIps < ActiveRecord::Migration
  def change
    create_table :ips do |t|
      t.string :name

      t.timestamps
    end
  end
end
