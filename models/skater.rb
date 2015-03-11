class Skater < ActiveRecord::Base
  has_many :scores
  has_many :competitions, through: :scores
end
