class VersionDecorator < ApplicationDecorator
  decorates :version

  def changes
    version.changes.collect(&:description)
  end

  def link_string
    number.gsub('.', '_')
  end
end
