class AddUnderwritingToPledger < ActiveRecord::Migration
  def change
    add_column :pledgers, :underwriting, :boolean
  end
end
