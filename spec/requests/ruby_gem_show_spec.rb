require 'spec_helper'

describe "Visiting a gem's page" do
  let(:gem) { RubyGem.find_by_name('none_such') }

  before(:each) do
    visit ruby_gem_url(gem)
  end

  it "shows the gem's name" do
    page.should have_content('none_such')
  end

  it "displays the most recent version" do
    page.should have_content('1.0.1')
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

  it "displays the all changes for the gem, most recent first" do
    current_version_lis = all('ul.all_versions>li').to_enum

    version_li = current_version_lis.next
    version_li.should have_content('1.0.1')
    version_li.find('.changes').should have_content("Fixed bug involving calling NoneSuch::Portal.new when already within another portal's execution block.")

    version_li = current_version_lis.next
    version_li.should have_content('1.0.0')
    version_li.find('.changes').should have_content('Solidified API.')
    version_li.find('.changes').should have_content('Reduced entropy caused by calling NoneSuch::Collider.collide!')

    version_li = current_version_lis.next
    version_li.should have_content('0.1.1')
    version_li.find('.changes').should have_content('Update contributers in gemspec.')
    version_li.find('.changes').should have_content('Fixed a bug where a NoneSuch::Portal would forget where it was anchored and destroy permanently anything that passed through.')
    version_li.find('.changes').should have_content('Fixed a divide-by-zero bug.')

    version_li = current_version_lis.next
    version_li.should have_content('0.1.0')
    version_li.find('.changes').should have_content('Added direct access to NoneSuch::Collider.')

    version_li = current_version_lis.next
    version_li.should have_content('0.0.2')
    version_li.find('.changes').should have_content("Fix bug in NoneSuch::Portal which increased a programmer's chance of contracting rabies.")
    version_li.find('.changes').should have_content('Updated README.')

    version_li = current_version_lis.next
    version_li.should have_content('0.0.1')
    version_li.find('.changes').should have_content('Initial release.')
  end

  it "renders plaintext release notes as preformatted" do
    find('#0_0_2 .changes pre').text.should == <<-CONTENT
* Fix bug in NoneSuch::Portal which increased a programmer's chance of contracting rabies.
* Updated README.
CONTENT
  end

  it "renders markdown" do
    note_lis = find('#0_1_1 .changes ul').all('li').to_enum

    note_li = note_lis.next
    note_li.should have_content('Update contributers in gemspec.')

    note_li = note_lis.next
    note_li.should have_content('Fixed a bug where a NoneSuch::Portal would forget where it was anchored and destroy permanently anything that passed through.')
    note_li.find('code').should have_content('NoneSuch::Portal')

    note_li = note_lis.next
    note_li.should have_content('Fixed a divide-by-zero bug.')
  end
end
