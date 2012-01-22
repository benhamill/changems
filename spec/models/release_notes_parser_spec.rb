require 'spec_helper'

describe ReleaseNotesParser do
  describe "::Markdown" do
    let(:markdown_release_notes) { File.read("#{Rails.root}/spec/support/markdown.md") }
    subject { ReleaseNotesParser::Markdown.parse(markdown_release_notes) }

    it "pulls version numbers from H2s" do
      subject.keys.sort.should == %w(3.1.3 3.1.2 3.1.1 3.1.0).sort
    end

    it "treats text between H2s as release notes"
  end
end
