class CorrectSpellingOfExtension < ActiveRecord::Migration
  def change
    change_table :versions do |t|
      t.rename :file_extention, :file_extension
    end
  end
end
