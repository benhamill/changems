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
      it "matches the #{ext.inspect} file extension" do
        FileExtension.new(ext).markdown?.should be_true
      end
    end

    it "doesn't match the swamdown file extension" do
      FileExtension.new('swamdown').markdown?.should be_false
    end
  end

  describe "#plaintext?" do
    ['', 'txt'].each do |ext|
      it "matches the #{ext.inspect} file extension" do
        FileExtension.new(ext).plaintext?.should be_true
      end
    end

    it "doesn't match the footxtbar file extension" do
      FileExtension.new('footxtbar').plaintext?.should be_false
    end
  end
end
