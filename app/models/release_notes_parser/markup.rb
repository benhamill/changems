Treetop.load "#{File.dirname(__FILE__)}/markup"

module ReleaseNotesParser
  module Markup
    def self.parse(release_notes, parser)
      parser.root = :notes
      tree = parser.parse(release_notes)

      if tree.nil?
        raise "Error parsing #{self.name} at #{parser.index}."
      end

      tree.to_hash
    end

    class Notes < Treetop::Runtime::SyntaxNode
      def to_hash
        elements.last.to_hash
      end
    end

    class Releases < Treetop::Runtime::SyntaxNode
      def to_hash
        elements.inject({}) do |memo, release|
          version_number = release.release_line.release_description.version_number.text_value
          release_notes = release.release_note.text_value

          memo[version_number] = release_notes

          memo
        end
      end
    end
  end
end
