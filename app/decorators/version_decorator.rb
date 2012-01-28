class VersionDecorator < ApplicationDecorator
  decorates :version

  def link_string
    number.gsub('.', '_')
  end

  def release_notes
    @rendered_release_notes ||= render_release_notes.html_safe
  end

  private

  def render_release_notes
    file_extension = FileExtension.new(version.file_extension)

    if file_extension.markdown?
      Redcarpet::Markdown.new(Redcarpet::Render::HTML.new(filter_html: true, no_styles: true), no_intra_emphasis: true, fenced_code_blocks: true, autolink: true).render(version.release_notes)
    elsif file_extension.rdoc?
      RDoc::Markup::ToHtml.new.convert(version.release_notes)
    else # Assume plaintext
      "<pre>#{version.release_notes}</pre>"
    end
  end
end
