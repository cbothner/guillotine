class CreateSlots < ActiveRecord::Migration
  def change
    create_table :slots do |t|
      t.integer :semester
      t.integer :weekday
      t.time :start
      t.time :end

      t.timestamps
    end
    change_table :shows do |t|
      t.remove :semester, :weekday, :start, :end
    end
  end
end
