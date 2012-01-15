class CreateChanges < ActiveRecord::Migration
  def change
    create_table :changes do |t|
      t.text :description
      t.integer :version_id

      t.timestamps
    end
  end
end
