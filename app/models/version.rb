class Version < ActiveRecord::Base
  belongs_to :ruby_gem
  has_many :changes

  before_save :split_out_version_number

  def self.semantic_order(sort = 'asc')
    self.order(
      "#{self.table_name}.major #{sort}",
      "#{self.table_name}.minor #{sort}",
      "#{self.table_name}.patch #{sort}",
      "#{self.table_name}.prerelease #{sort}"
    )
  end

  private

  def split_out_version_number
    gv = Gem::Version.new(number)

    self.major, self.minor, self.patch = gv.release.segments

    self.prerelease = number.match(/[a-zA-Z]+.*/).to_s

    self.prerelease = nil if self.prerelease.blank?
    self.major ||= 0
    self.minor ||= 0
    self.patch ||= 0
  end
end
