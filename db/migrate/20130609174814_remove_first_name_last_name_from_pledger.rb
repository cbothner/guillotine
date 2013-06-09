class RemoveFirstNameLastNameFromPledger < ActiveRecord::Migration
  def up
    remove_column :pledgers, :first_name
    remove_column :pledgers, :last_name
    add_column :pledgers, :name, :string
  end

  def down
    add_column :pledgers, :first_name, :string
    add_column :pledgers, :last_name, :string
    remove_column :pledgers, :name
  end
end
