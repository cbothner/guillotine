class CreateRewards < ActiveRecord::Migration
  def change
    create_table :rewards do |t|
      t.references :pledger
      t.references :item
      t.boolean :premia_sent
      t.text :comment

      t.timestamps
    end
    add_index :rewards, :pledger_id
    add_index :rewards, :item_id
  end
end
