class CreateFixedTrips < ActiveRecord::Migration[6.0]
  def change
    create_table :fixed_trips do |t|
      t.references :trip,       null: false, foreign_key: true
      t.references :detail,     null: false, foreign_key: true
      t.timestamps
    end
  end
end
