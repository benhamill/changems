RubyGem.create(:name => 'none_such') do |gem|
  gem.versions.build(:number => '1.0.0') do |version|
    version.changes.build(:description => 'Solidified API.')
    version.changes.build(:description => 'Reduced entropy caused by calling NoneSuch::Collider.collide!')
  end

  gem.versions.build(:number => '1.0.1') do |version|
    version.changes.build(:description => "Fixed bug involving calling NoneSuch::Portal.new when already within another portal's execution block.")
  end
end
