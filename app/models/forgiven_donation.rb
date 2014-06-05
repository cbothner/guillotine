class ForgivenDonation < ActiveRecord::Base
  belongs_to :pledger, :inverse_of => :forgiven_donations
  belongs_to :slot, :inverse_of => :forgiven_donations
  attr_accessible :amount, :gpo_processed, :gpo_sent, :payment_method, :payment_received, :pledge_form_sent, :slot_id, :phone_operator, :pledger_id
end
