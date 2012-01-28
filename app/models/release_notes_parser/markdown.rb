Treetop.load "#{File.dirname(__FILE__)}/markdown"

module ReleaseNotesParser
  module Markdown
    def self.parse(release_notes)
      Markup.parse(release_notes, MarkdownParser.new)
    end
  end
end
