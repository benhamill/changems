Treetop.load "#{File.dirname(__FILE__)}/rdoc"

module ReleaseNotesParser
  module RDoc
    def self.parse(release_notes)
      Markup.parse(release_notes, RDocParser.new)
    end
  end
end
