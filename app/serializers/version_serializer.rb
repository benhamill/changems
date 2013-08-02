class VersionSerializer < ActiveModel::Serializer
  attributes :number, :gem_name, :major, :minor, :patch, :release_notes

  def gem_name
    object.ruby_gem.name
  end
end
