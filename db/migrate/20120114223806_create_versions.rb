class CreateVersions < ActiveRecord::Migration
  def change
    create_table :versions do |t|
      t.string :number
      t.integer :ruby_gem_id

      t.timestamps
    end
  end
end
