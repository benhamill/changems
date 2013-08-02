class VersionSerializer < ActiveModel::Serializer
  attributes :number, :ruby_gem_id, :major, :minor, :patch, :release_notes
end
