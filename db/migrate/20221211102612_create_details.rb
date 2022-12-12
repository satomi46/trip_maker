class CreateDetails < ActiveRecord::Migration[6.0]
  def change
    create_table :details do |t|
      t.references :trip,       null: false, foreign_key: true
      t.string     :title,      null: false, default: ""
      t.string     :note
      t.string     :address
      t.datetime   :time
      t.string     :time_note
      t.integer    :importance, null: false
      t.string     :url
      t.integer    :fixed

      t.timestamps
    end
  end
end
