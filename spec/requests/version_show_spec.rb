require 'spec_helper'

describe "Visiting a version's page" do
  let(:version) { RubyGem.find_by_name('none_such').current_version }

  before(:each) do
    visit version_url(version)
  end
end
