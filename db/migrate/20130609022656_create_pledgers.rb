class CreatePledgers < ActiveRecord::Migration
  def change
    create_table :pledgers do |t|
      t.boolean :individual
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :affiliation
      t.string :local_phone
      t.string :local_address
      t.string :local_address2
      t.string :local_city
      t.string :local_state
      t.string :local_zip
      t.string :perm_phone
      t.string :perm_address
      t.string :perm_address2
      t.string :perm_city
      t.string :perm_state
      t.string :perm_zip
      t.string :perm_country

      t.timestamps
    end
  end
end
