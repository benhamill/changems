require 'spec_helper'

describe ReleaseNotesParser do
  describe "::Markdown" do
    let(:markdown_release_notes) { File.read("#{Rails.root}/spec/support/markdown.md") }
    subject { ReleaseNotesParser::Markdown.parse(markdown_release_notes) }

    it "pulls version numbers from H2s" do
      subject.keys.sort.should == %w(3.1.3 3.1.2 3.1.1 3.1.0).sort
    end

    it "treats text between H2s as release notes" do
      subject['3.1.3'].should == <<-NOTES
*   Perf fix: If we're deleting all records in an association, don't add a IN(..) clause
    to the query. *GH 3672*

    *Jon Leighton*

*   Fix bug with referencing other mysql databases in set_table_name. *GH 3690*

*   Fix performance bug with mysql databases on a server with lots of other databses. *GH 3678*

    *Christos Zisopoulos and Kenny J*
NOTES
    end
  end
end
