require 'spec_helper'

describe "Visiting a version range page" do
  let(:gem) { RubyGem.find_by_name('none_such') }

  before(:each) do
    visit ruby_gem_url(gem)

    select '0.1.1', from: 'Start version'
    select '1.0.1', from: 'End version'

    click_button 'View Range'
  end

  it "shows the gem's name" do
    page.should have_content('none_such')
  end

  it "lists the version range" do
    page.should have_content('0.1.1 - 1.0.1')
  end

  it "lists all the changes for each of the versions in the range" do
    version_lis = all('ul.versions>li')

    version_lis[0].should have_content('0.1.1')
    changes_lis = version_lis[0].all('ul.changes>li')
    changes_lis[0].should have_content('Update contributers in gemspec.')
    changes_lis[1].should have_content('Fixed a bug where a NoneSuch::Portal would forget where it was anchored and destroy permanently anything that passed through.')
    changes_lis[2].should have_content('Fixed a divide-by-zero bug.')

    version_lis[1].should have_content('1.0.0')
    changes_lis = version_lis[1].all('ul.changes>li')
    changes_lis[0].should have_content('Solidified API.')
    changes_lis[1].should have_content('Reduced entropy caused by calling NoneSuch::Collider.collide!')

    version_lis[2].should have_content('1.0.1')
    changes_lis = version_lis[2].all('ul.changes>li')
    changes_lis[0].should have_content("Fixed bug involving calling NoneSuch::Portal.new when already within another portal's execution block.")
  end
end
