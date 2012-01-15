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
    find('.versions').should have_content('1.0.0')
    find('.versions').should have_content('1.0.1')
  end

  it "displays the most recent version" do
    find('.current_version').should have_content('1.0.1')
  end

  it "displays the changes for the most recent major version number" do
    find('.current_version .changes').should have_content("Fixed bug involving calling NoneSuch::Portal.new when already within another portal's execution block.")
  end
end
