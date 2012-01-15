require 'spec_helper'

describe "Visiting the homepage" do
  context "with no search term" do
    before(:each) do
      visit root_path
    end

    it "displays a welcome message" do
      page.should have_content("Welcome")
    end
  end

  context "with a search term" do
    before(:each) do
      visit root_path
      fill_in 'search', with: 'none'
      click_button 'Search'
    end

    it "displays matching gems" do
      page.should have_link('none_such')
    end
  end
end
