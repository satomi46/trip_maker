class Trip < ApplicationRecord
  validates :image,      presence: true
  validates :title,      presence: true
  validates :start_date, presence: true
  validates :end_date,   presence: true
  validate  :start_end_check

  def start_end_check
    if self.start_date != nil && self.end_date != nil 
      errors.add(:end_date, 'must be same or later than Start date') unless self.start_date <= self.end_date 
    end
  end

  has_many :trip_users
  has_many :users, through: :trip_users
  has_one_attached :image
end
