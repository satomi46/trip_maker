class CreateTrips < ActiveRecord::Migration[6.0]
  def change
    create_table :trips do |t|
      t.string :title,      null: false, default: ""
      t.date   :start_date, null: false
      t.date   :end_date,   null: false
      t.timestamps
    end
  end
end
