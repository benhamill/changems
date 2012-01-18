require 'spec_helper'

describe "Visiting a gem's page" do
  let(:gem) { RubyGem.find_by_name('none_such') }

  before(:each) do
    visit ruby_gem_url(gem)
  end

  it "shows the gem's name" do
    page.should have_content('none_such')
  end

  it "lists the known versions" do
    lis = find('.versions').all('li').to_enum

    lis.next.should have_link('1.0.1', href: "#1_0_1")
    lis.next.should have_link('1.0.0', href: "#1_0_0")
    lis.next.should have_link('0.1.1', href: "#0_1_1")
    lis.next.should have_link('0.1.0', href: "#0_1_0")
    lis.next.should have_link('0.0.2', href: "#0_0_2")
    lis.next.should have_link('0.0.1', href: "#0_0_1")
  end

  it "displays the most recent version" do
    find('.current_version').should have_content('1.0.1')
  end

  it "displays the all changes for the gem, most recent first" do
    current_version_lis = all('ul.all_versions>li').to_enum

    version_li = current_version_lis.next
    version_li.should have_content('1.0.1')
    changes_lis = version_li.all('ul.changes>li').to_enum
    changes_lis.next.should have_content("Fixed bug involving calling NoneSuch::Portal.new when already within another portal's execution block.")

    version_li = current_version_lis.next
    version_li.should have_content('1.0.0')
    changes_lis = version_li.all('ul.changes>li').to_enum
    changes_lis.next.should have_content('Solidified API.')
    changes_lis.next.should have_content('Reduced entropy caused by calling NoneSuch::Collider.collide!')

    version_li = current_version_lis.next
    version_li.should have_content('0.1.1')
    changes_lis = version_li.all('ul.changes>li').to_enum
    changes_lis.next.should have_content('Update contributers in gemspec.')
    changes_lis.next.should have_content('Fixed a bug where a NoneSuch::Portal would forget where it was anchored and destroy permanently anything that passed through.')
    changes_lis.next.should have_content('Fixed a divide-by-zero bug.')

    version_li = current_version_lis.next
    version_li.should have_content('0.1.0')
    changes_lis = version_li.all('ul.changes>li').to_enum
    changes_lis.next.should have_content('Added direct access to NoneSuch::Collider.')

    version_li = current_version_lis.next
    version_li.should have_content('0.0.2')
    changes_lis = version_li.all('ul.changes>li').to_enum
    changes_lis.next.should have_content("Fix bug in NoneSuch::Portal which increased a programmer's chance of contracting rabies.")
    changes_lis.next.should have_content('Updated README.')

    version_li = current_version_lis.next
    version_li.should have_content('0.0.1')
    changes_lis = version_li.all('ul.changes>li').to_enum
    changes_lis.next.should have_content('Initial release.')
  end
end
