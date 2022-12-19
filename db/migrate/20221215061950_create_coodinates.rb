class CreateCoodinates < ActiveRecord::Migration[6.0]
  def change
    create_table :coodinates do |t|
      t.string  :address,     null: false
      t.decimal :latitude,    null: false, precision: 11, scale: 8
      t.decimal :longitude,   null: false, precision: 11, scale: 8
      t.timestamps
    end
  end
end
