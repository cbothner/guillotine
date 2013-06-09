class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :name
      t.decimal :taxable_value
      t.decimal :cost
      t.integer :stock
      t.boolean :backorderable
      t.string :shape
      t.text :note

      t.timestamps
    end
  end
end
