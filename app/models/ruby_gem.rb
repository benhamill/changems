class RubyGem < ActiveRecord::Base
  has_many :versions

  def current_version
    versions.max do |a, b|
      Gem::Version.new(a.number) <=> Gem::Version.new(b.number)
    end
  end
end
