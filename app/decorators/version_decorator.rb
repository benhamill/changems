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
    if version.file_extension =~ /md|mkdn?|mdown|markdown/
      Redcarpet::Markdown.new(Redcarpet::Render::HTML.new(filter_html: true, no_styles: true), no_intra_emphasis: true, fenced_code_blocks: true, autolink: true).render(version.release_notes)
    else # Assume plaintext
      "<pre>#{version.release_notes}</pre>"
    end
  end
end
