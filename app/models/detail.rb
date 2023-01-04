class Detail < ApplicationRecord
  validates :title,      presence: true
  validates :importance, presence: true

  belongs_to :trip
  has_one :fixed_trip, dependent: :destroy
end
