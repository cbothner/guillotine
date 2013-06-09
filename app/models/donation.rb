class Donation < ActiveRecord::Base
  belongs_to :pledger, :inverse_of => :donations
  belongs_to :show, :inverse_of => :donations
  attr_accessible :amount, :gpo_processed, :gpo_sent, :payment_method, :payment_received, :pledge_form_sent

  validates :amount, :payment_method, :presence => true
  validates :amount, :numericality => { :greater_than => 0 }
  validates :payment_method, :inclusion => { :in => ["Credit Card","Cash","Cheque"], :message => "Payment method must be one of the following: Credit Card, Cash, or Cheque." }
end
