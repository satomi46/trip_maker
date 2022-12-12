class Trip < ApplicationRecord
  validates :image,      presence: true
  validates :title,      presence: true
  validates :start_date, presence: true
  validates :end_date,   presence: true
  validate  :start_end_check

  def start_end_check
    return if start_date.nil? || end_date.nil? || start_date <= end_date

    errors.add(:end_date, 'must be same or later than Start date')
  end

  has_many :trip_users, dependent: :destroy
  has_many :users, through: :trip_users
  has_many :details, dependent: :destroy
  has_one_attached :image
end
