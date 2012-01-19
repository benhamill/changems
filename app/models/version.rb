class Version < ActiveRecord::Base
  belongs_to :ruby_gem

  before_save :split_out_version_number

  def self.semantic_order(sort = 'asc')
    self.order(
      "#{self.table_name}.major #{sort}",
      "#{self.table_name}.minor #{sort}",
      "#{self.table_name}.patch #{sort}",
      "#{self.table_name}.prerelease #{sort}"
    )
  end

  def self.between(start_version, end_version)
    version_hash = {
      start_major: start_version.major,
      start_minor: start_version.minor,
      start_patch: start_version.patch,
      start_prerelease: start_version.prerelease,
      end_major: end_version.major,
      end_minor: end_version.minor,
      end_patch: end_version.patch,
      end_prerelease: end_version.prerelease,
    }

    where(<<-SQL, version_hash)
      (
        versions.major = :start_major AND
        versions.minor = :start_minor AND
        versions.patch = :start_patch AND
        versions.prerelease >= :start_prerelease
      ) OR (
        versions.major = :start_major AND
        versions.minor = :start_minor AND
        versions.patch > :start_patch
      ) OR (
        versions.major = :start_major AND
        versions.minor > :start_minor
      ) OR (
        versions.major > :start_major AND
        versions.major < :end_major
      ) OR (
        versions.major = :end_major AND
        versions.minor < :end_minor
      ) OR (
        versions.major = :end_major AND
        versions.minor = :end_minor AND
        versions.patch < :end_patch
      ) OR (
        versions.major = :end_major AND
        versions.minor = :end_minor AND
        versions.patch = :end_patch AND
        versions.prerelease <= :end_prerelease
      )
    SQL
  end

  private

  def split_out_version_number
    gv = Gem::Version.new(number)

    self.major, self.minor, self.patch = gv.release.segments

    self.prerelease = number.match(/[a-zA-Z]+.*/).to_s
    self.major ||= 0
    self.minor ||= 0
    self.patch ||= 0
  end
end
