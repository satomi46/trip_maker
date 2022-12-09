class Trip < ApplicationRecord
  validates :image,      presence: true
  validates :title,      presence: true
  validates :start_date, presence: true
  validates :end_date,   presence: true

  has_many :trip_users
  has_many :users, through: :trip_users
  has_one_attached :image
end
