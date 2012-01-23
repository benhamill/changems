class RubyGem < ActiveRecord::Base
  has_many :versions

  def self.featured
    self.where(featured: true)
  end

  def current_version_number
    v = versions.semantic_order('desc').limit(1).first

    v and v.number or '0.0.0.0.0.z0'
  end

  def import_release_notes
    ReleaseNotesImporter.import(name)
  end
end
