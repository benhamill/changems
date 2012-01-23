class RubyGem < ActiveRecord::Base
  has_many :versions

  def current_version
    versions.semantic_order('desc').limit(1).first
  end

  def import_release_notes
    ReleaseNotesImporter.import(name)
  end
end
