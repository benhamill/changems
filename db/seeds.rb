RubyGem.create(name: 'none_such') do |gem|
  gem.versions.build(number: '0.0.1') do |version|
    version.changes.build(description: 'Initial release.')
  end

  gem.versions.build(number: '0.1.0') do |version|
    version.changes.build(description: 'Added direct access to NoneSuch::Collider.')
  end

  gem.versions.build(number: '0.1.1') do |version|
    version.changes.build(description: 'Update contributers in gemspec.')
    version.changes.build(description: 'Fixed a bug where a NoneSuch::Portal would forget where it was anchored and destroy permanently anything that passed through.')
    version.changes.build(description: 'Fixed a divide-by-zero bug.')
  end

  gem.versions.build(number: '0.0.2') do |version|
    version.changes.build(description: "Fix bug in NoneSuch::Portal which increased a programmer's chance of contracting rabies.")
    version.changes.build(description: 'Updated README.')
  end

  gem.versions.build(number: '1.0.0') do |version|
    version.changes.build(description: 'Solidified API.')
    version.changes.build(description: 'Reduced entropy caused by calling NoneSuch::Collider.collide!')
  end

  gem.versions.build(number: '1.0.1') do |version|
    version.changes.build(description: "Fixed bug involving calling NoneSuch::Portal.new when already within another portal's execution block.")
  end
end
