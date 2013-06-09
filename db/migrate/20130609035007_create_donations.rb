class CreateDonations < ActiveRecord::Migration
  def change
    create_table :donations do |t|
      t.references :pledger
      t.references :show
      t.decimal :amount
      t.string :payment_method
      t.boolean :pledge_form_sent
      t.boolean :payment_received
      t.boolean :gpo_sent
      t.boolean :gpo_processed

      t.timestamps
    end
    add_index :donations, :pledger_id
    add_index :donations, :show_id
  end
end
