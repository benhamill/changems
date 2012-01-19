require 'spec_helper'

describe VersionDecorator do
  before { ApplicationController.new.set_current_view_context }

  it "treats plaintext as preformatted"
  it "parses markdown"
end
