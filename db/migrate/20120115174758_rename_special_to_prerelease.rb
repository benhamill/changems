class RenameSpecialToPrerelease < ActiveRecord::Migration
  def change
    change_table :versions do |t|
      t.rename :special, :prerelease
    end
  end
end
