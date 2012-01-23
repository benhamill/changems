class AddFeaturedToRubyGems < ActiveRecord::Migration
  def change
    change_table :ruby_gems do |t|
      t.boolean :featured, default: false
      t.index :featured
    end
  end
end
