class CreatePackages < ActiveRecord::Migration
  def change
    create_table :packages do |t|
      t.string :sort
      t.string :package_array
      t.integer :instance_id
      t.integer :path_id

      t.timestamps
    end
  end
end
