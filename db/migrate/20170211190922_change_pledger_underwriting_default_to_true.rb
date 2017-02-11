class ChangePledgerUnderwritingDefaultToTrue < ActiveRecord::Migration
  def change
    change_column :pledgers, :underwriting, :boolean, default: false
  end
end
