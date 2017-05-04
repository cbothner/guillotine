class CreateSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|
      t.string :key
      t.string :value

      t.timestamps
    end
    add_index :settings, :key, unique: true

    reversible do |dir|
      dir.up do
        Setting.create key: 'dd_name', value: 'DD Name'
        Setting.create key: 'dd_phone', value: '1234567890'
      end
      dir.down do
      end
    end
  end
end
