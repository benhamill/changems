class AddFileExtentionToVersions < ActiveRecord::Migration
  def change
    change_table :versions do |t|
      t.text :file_extention, default: ''
    end
  end
end
