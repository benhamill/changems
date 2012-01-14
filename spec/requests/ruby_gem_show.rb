require 'spec_helper'

describe "Visiting a gem's page" do
  before(:all) do
    @gem = RubyGem.create(:name => 'texticle')
  end

  before(:each) do
    visit ruby_gem_url(@gem)
  end

  it "shows the gem's name" do
    page.should have_content('texticle')
  end
end
