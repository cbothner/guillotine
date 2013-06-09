class CreateShows < ActiveRecord::Migration
  def change
    create_table :shows do |t|
      t.integer :semester
      t.integer :weekday
      t.time :start
      t.time :end
      t.string :name
      t.string :dj

      t.timestamps
    end
  end
end
