require 'spec_helper'

describe "Visiting a version's page" do
  let(:version) { RubyGem.find_by_name('none_such').current_version }

  before(:each) do
    visit version_url(version)
  end

  it "shows the gem's name" do
    page.should have_content('none_such')
  end

  it "shows the version's number" do
    page.should have_content('1.0.1')
  end

  it "lists the changes for that version" do
    page.should have_content("Fixed bug involving calling NoneSuch::Portal.new when already within another portal's execution block.")
  end
end
