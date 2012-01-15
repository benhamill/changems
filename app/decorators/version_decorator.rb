class VersionDecorator < ApplicationDecorator
  decorates :version

  def changes
    version.changes.collect(&:description)
  end
end
