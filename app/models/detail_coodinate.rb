class DetailCoodinate
  include ActiveModel::Model
  attr_accessor :trip_id, :title, :note, :address, :time, :time_note, :importance, :url, :fixed, :latitude, :longitude

  validates :title,      presence: true
  validates :importance, presence: true

  def save
    Detail.create(title: title, note: note, address: address, time: time, time_note: time_note, importance: importance,
                      url: url, fixed: fixed, trip_id: trip_id)

    if address != ""
      Coodinate.find_or_create_by(address: address, latitude: latitude, longitude: longitude)
    end
  end
end