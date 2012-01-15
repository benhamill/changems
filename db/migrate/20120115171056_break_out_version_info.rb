class BreakOutVersionInfo < ActiveRecord::Migration
  def change
    change_table :versions do |t|
      t.integer :major, default: 0
      t.integer :minor, default: 0
      t.integer :patch, default: 0
      t.string :special

      t.index [:major, :minor, :patch, :special]
    end
  end
end
