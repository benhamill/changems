class Version < ActiveRecord::Base
  belongs_to :ruby_gem
  has_many :changes

  before_save :split_out_version_number

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
