module ReleaseNotesParser
  class UnknownFileTypeError < StandardError; end

  def self.parse(release_notes, file_extension)
    parser_for(file_extension).parse(release_notes)
  end

  private

  def self.parser_for(file_extension)
    file_extension = FileExtension.new(file_extension)

    if file_extension.markdown?
      ReleaseNotesParser::Markdown
    elsif file_extension.rdoc?
      ReleaseNotesParser::Rdoc
    else
      raise ReleaseNotesParser::UnknownFileTypeError, "Cannot parse files of type #{file_extension.to_s.inspect}"
    end
  end
end
