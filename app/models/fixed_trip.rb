class FixedTrip < ApplicationRecord
  validates :trip_id,   presence: true
  validates :detail_id, presence: true

  belongs_to :trip
  belongs_to :detail
end
