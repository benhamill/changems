require 'spec_helper'

describe "Visiting a gem's page" do
  let(:gem) { RubyGem.create(:name => 'texticle') }

  before(:each) do
    visit ruby_gem_url(gem)
  end

  it "shows the gem's name" do
    page.should have_content('texticle')
  end

  context "with no versions" do
    before(:each) do
      gem.versions.destroy_all
    end

    it "doesn't list any versions" do
      page.should have_no_selector('.versions')
    end
  end

  context "with some versions" do
    before(:each) do
      gem.versions.create(:number => '1.0.0')
      gem.versions.create(:number => '1.0.1')
      visit ruby_gem_url(gem)
    end

    it "lists the known versions" do
      find('.versions').should have_content('1.0.0')
      find('.versions').should have_content('1.0.1')
    end
  end
end
