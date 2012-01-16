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
    lis = find('.versions').all('li')

    lis[0].should have_content('0.0.1')
    lis[1].should have_content('0.0.2')
    lis[2].should have_content('0.1.0')
    lis[3].should have_content('0.1.1')
    lis[4].should have_content('1.0.0')
    lis[5].should have_content('1.0.1')
  end

  it "displays the most recent version" do
    find('.current_version').should have_content('1.0.1')
  end

  it "displays the changes for the most recent major version number" do
    find('.current_version .changes').should have_content("Fixed bug involving calling NoneSuch::Portal.new when already within another portal's execution block.")
  end

  it "has a form for seeing all the changes between two versions" do
    find('.range_form').should have_select('start_version', options: %w(0.0.1 0.0.2 0.1.0 0.1.1 1.0.0))
    find('.range_form').should have_select('end_version', options: %w(0.0.2 0.1.0 0.1.1 1.0.0 1.0.1))
  end
end
