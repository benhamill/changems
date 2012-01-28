require 'spec_helper'

describe ReleaseNotesParser do
  describe "::Markdown" do
    let(:markdown_release_notes) { File.read(Rails.root.join(*%w(spec support markdown.md))) }

    subject { ReleaseNotesParser::Markdown.parse(markdown_release_notes) }

    it "pulls version numbers from H2s" do
      subject.keys.sort.should == %w(3.1.3 3.1.2 3.1.1 3.1.0).sort
    end

    it "treats text between H2s as release notes" do
      subject['3.1.3'].should == <<-NOTES
*   Perf fix: If we're deleting all records in an association, don't add a IN(..) clause
    to the query. *GH 3672*

    *Jon Leighton*

*   Fix bug with referencing other mysql databases in set_table_name. *GH ##3690*

*   Fix performance bug with mysql databases on a server with lots of other databses. *GH 3678*

    *Christos Zisopoulos and Kenny J*

NOTES
    end
  end

  describe "::Rdoc" do
    let(:rdoc_release_notes) { File.read(Rails.root.join(*%w(spec support rdoc.rdoc))) }

    subject { ReleaseNotesParser::Rdoc.parse(rdoc_release_notes) }

    it "pulls version numbers from H2s" do
      subject.keys.sort.should == %w(1.5.1 1.5.0 1.4.7 1.4.6 1.4.5).sort
    end

    it "treats text between H2s as release notes" do
      subject['1.5.0'].should == <<-NOTES
* Notes

  * See changelog from 1.4.7

* Features

  * extracted sets of Node::SaveOptions into Node::SaveOptions::DEFAULT_{X,H,XH}TML (refactor)

* Bugfixes

  * default output of XML on JRuby is no longer formatted due to
    inconsistent whitespace handling. #415
  * (JRuby) making empty NodeSets with null `nodes` member safe to operate on. #443
  * Fix a bug in advanced encoding detection that leads to partially
    duplicated document when parsing an HTML file with unknown
    encoding.
  * Add support for <meta charset="...">.

NOTES
    end
  end
end
