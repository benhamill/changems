require 'spec_helper'

describe "Visiting the homepage" do
  before(:each) do
    visit root_url
  end

  it "displays the site title" do
    page.should have_content("Changems")
  end
end
