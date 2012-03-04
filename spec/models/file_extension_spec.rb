require 'spec_helper'

describe FileExtension do
  describe ".from_file_name" do
    it "pulls off file_extensions" do
      FileExtension.from_file_name('foo.bar.md').to_s.should == 'md'
    end

    it "knows when there is no file extension" do
      FileExtension.from_file_name('CHANGES').to_s.should == ''
    end
  end

  describe "#markdown?" do
    %w(md mkd mkdn mdown markdown).each do |ext|
      it "matches the '#{ext}' file extension" do
        FileExtension.new(ext).should be_markdown
      end
    end

    it "doesn't match the 'swamdown' file extension" do
      FileExtension.new('swamdown').should_not be_markdown
    end
  end

  describe "#plaintext?" do
    ['', 'txt'].each do |ext|
      it "matches the '#{ext}' file extension" do
        FileExtension.new(ext).should be_plaintext
      end
    end

    it "doesn't match the 'footxtbar' file extension" do
      FileExtension.new('footxtbar').should_not be_plaintext
    end
  end

  describe "#rdoc?" do
    it "matches the 'rdoc' extension" do
      FileExtension.new('rdoc').should be_rdoc
    end

    it "doesn't match the 'foordocbar' file extension" do
      FileExtension.new('foordocbar').should_not be_rdoc
    end
  end
end
