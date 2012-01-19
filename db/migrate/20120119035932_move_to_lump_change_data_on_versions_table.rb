class MoveToLumpChangeDataOnVersionsTable < ActiveRecord::Migration
  def change
    drop_table :changes

    change_table :versions do |t|
      t.text :release_notes, :null => false
    end
  end
end
