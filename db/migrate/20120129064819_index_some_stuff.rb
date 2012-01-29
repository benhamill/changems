class IndexSomeStuff < ActiveRecord::Migration
  def change
    add_index :ruby_gems, :name, unique: true
    add_index :versions, [:number, :ruby_gem_id], unique: true
  end
end
