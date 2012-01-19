class VersionDecorator < ApplicationDecorator
  decorates :version

  def link_string
    number.gsub('.', '_')
  end
end
