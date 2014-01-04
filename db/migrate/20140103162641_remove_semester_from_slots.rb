class RemoveSemesterFromSlots < ActiveRecord::Migration
  def change
    change_table :slots do |t|
      t.remove :semester
    end
  end
end
