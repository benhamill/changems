class Version < ActiveRecord::Base
  belongs_to :ruby_gem
  has_many :changes
end
