class Score < ActiveRecord::Base
  has_many :elements, dependent: :destroy
  has_many :components, dependent: :destroy

  belongs_to :skater
  belongs_to :competition
end
