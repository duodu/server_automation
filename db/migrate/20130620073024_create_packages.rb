class CreatePackages < ActiveRecord::Migration
  def change
    create_table :packages do |t|
      t.string :sort
      t.text :package_array
      t.string :ip
      t.string :username
      t.integer :path_id
      t.datetime :batch_date

      t.timestamps
    end
  end
end
