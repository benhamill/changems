class RubyGem < ActiveRecord::Base
  has_many :versions
end
