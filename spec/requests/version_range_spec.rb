require 'spec_helper'

describe "Visiting a version range page" do
  let(:gem) { RubyGem.find_by_name('none_such') }

  before(:each) do
    visit ruby_gem_url(gem)

    select '0.0.2', from: 'Start version'
    select '1.0.1', from: 'End version'

    click_button 'View Range'
  end

  it "shows the gem's name" do
    page.should have_content('none_such')
  end

  it "lists the version range" do
    page.should have_content('0.0.2 - 1.0.1')
  end

  it "lists all the changes for each of the versions in the range" do
    version_lis = all('ul.versions>li').to_enum

    version_li = version_lis.next
    version_li.should have_content('0.0.2')
    change_lis = version_li.all('ul.changes>li').to_enum
    change_lis.next.should have_content("Fix bug in NoneSuch::Portal which increased a programmer's chance of contracting rabies.")
    change_lis.next.should have_content('Updated README.')

    version_li = version_lis.next
    version_li.should have_content('0.1.0')
    change_lis = version_li.all('ul.changes>li').to_enum
    change_lis.next.should have_content('Added direct access to NoneSuch::Collider.')

    version_li = version_lis.next
    version_li.should have_content('0.1.1')
    changes_lis = version_li.all('ul.changes>li').to_enum
    changes_lis.next.should have_content('Update contributers in gemspec.')
    changes_lis.next.should have_content('Fixed a bug where a NoneSuch::Portal would forget where it was anchored and destroy permanently anything that passed through.')
    changes_lis.next.should have_content('Fixed a divide-by-zero bug.')

    version_li = version_lis.next
    version_li.should have_content('1.0.0')
    changes_lis = version_li.all('ul.changes>li').to_enum
    changes_lis.next.should have_content('Solidified API.')
    changes_lis.next.should have_content('Reduced entropy caused by calling NoneSuch::Collider.collide!')

    version_li = version_lis.next
    version_li.should have_content('1.0.1')
    changes_lis = version_li.all('ul.changes>li').to_enum
    changes_lis.next.should have_content("Fixed bug involving calling NoneSuch::Portal.new when already within another portal's execution block.")
  end
end
