class CreateForgivenDonations < ActiveRecord::Migration
  def change
    create_table :forgiven_donations do |t|
      t.integer  "pledger_id"
      t.integer  "slot_id"
      t.decimal  "amount"
      t.string   "payment_method"
      t.boolean  "pledge_form_sent"
      t.boolean  "payment_received"
      t.boolean  "gpo_sent"
      t.boolean  "gpo_processed"
      t.string   "phone_operator"
      t.datetime "created_at",       null: false
      t.datetime "updated_at",       null: false
    end
  end
end
