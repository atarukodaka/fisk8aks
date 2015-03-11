class Competition < ActiveRecord::Base
  has_many :scores
  has_many :skaters, through: :scores
end
