class SetFalseDefaultsOnBooleanColumns < ActiveRecord::Migration
  def change
    change_column_default :donations, :pledge_form_sent, false
    change_column_default :donations, :payment_received, false
    change_column_default :donations, :gpo_sent, false
    change_column_default :donations, :gpo_processed, false
    change_column_default :forgiven_donations, :pledge_form_sent, false
    change_column_default :forgiven_donations, :payment_received, false
    change_column_default :forgiven_donations, :gpo_sent, false
    change_column_default :forgiven_donations, :gpo_processed, false
    change_column_default :items, :backorderable, false
    change_column_default :pledgers, :individual, false
    change_column_default :rewards, :premia_sent, false
    change_column_default :rewards, :taxed, false

    change_column_null :donations, :pledge_form_sent, false, false
    change_column_null :donations, :payment_received, false, false
    change_column_null :donations, :gpo_sent, false, false
    change_column_null :donations, :gpo_processed, false, false
    change_column_null :forgiven_donations, :pledge_form_sent, false, false
    change_column_null :forgiven_donations, :payment_received, false, false
    change_column_null :forgiven_donations, :gpo_sent, false, false
    change_column_null :forgiven_donations, :gpo_processed, false, false
    change_column_null :items, :backorderable, false, false
    change_column_null :pledgers, :individual, false, false
    change_column_null :rewards, :premia_sent, false, false
    change_column_null :rewards, :taxed, false, false
  end
end
