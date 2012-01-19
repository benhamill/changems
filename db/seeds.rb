RubyGem.create(name: 'none_such') do |gem|
  gem.versions.build(number: '0.0.1', release_notes: <<-CHANGES, file_extention: 'txt')
* Initial release.
CHANGES

  gem.versions.build(number: '0.1.0', release_notes: <<-CHANGES, file_extention: 'txt')
* Added direct access to NoneSuch::Collider.
CHANGES

  gem.versions.build(number: '0.1.1', release_notes: <<-CHANGES, file_extention: 'txt')
* Update contributers in gemspec.
* Fixed a bug where a NoneSuch::Portal would forget where it was anchored and destroy permanently anything that passed through.
* Fixed a divide-by-zero bug.
CHANGES

  gem.versions.build(number: '0.0.2', release_notes: <<-CHANGES, file_extention: 'txt')
* Fix bug in NoneSuch::Portal which increased a programmer's chance of contracting rabies.
* Updated README.
CHANGES

  gem.versions.build(number: '1.0.0', release_notes: <<-CHANGES, file_extention: 'txt')
* Solidified API.
* Reduced entropy caused by calling NoneSuch::Collider.collide!
CHANGES

  gem.versions.build(number: '1.0.1', release_notes: <<-CHANGES, file_extention: 'txt')
* Fixed bug involving calling NoneSuch::Portal.new when already within another portal's execution block.
CHANGES
end
