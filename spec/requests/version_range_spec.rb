require 'spec_helper'

describe "Visiting a version range page" do
  let(:gem) { RubyGem.find_by_name('none_such') }

  before(:each) do
    visit ruby_gem_url(gem)

    select '0.1.1', from: :start_version
    select '1.0.1', from: :end_version

    click_button 'View Range'
  end
end
