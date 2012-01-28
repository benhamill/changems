Treetop.load "#{File.dirname(__FILE__)}/rdoc"

module ReleaseNotesParser
  module Rdoc
    def self.parse(release_notes)
      Markup.parse(release_notes, RdocParser.new)
    end
  end
end
