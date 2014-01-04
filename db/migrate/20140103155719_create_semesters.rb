class CreateSemesters < ActiveRecord::Migration
  def change
    create_table :semesters do |t|
      t.integer :year
      t.integer :month
      t.integer :goal

      t.timestamps
    end
    change_table :slots do |t|
      t.references :semester
    end
    add_index :slots, :semester_id
  end
end
