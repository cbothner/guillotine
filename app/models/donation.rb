class Donation < ActiveRecord::Base
  belongs_to :pledger, inverse_of: :donations
  belongs_to :slot, inverse_of: :donations
  attr_accessible :amount, :gpo_processed, :gpo_sent, :payment_method, :payment_received, :pledge_form_sent, :slot_id, :phone_operator, :comment

  validates :amount, :payment_method, presence: true
  validates :amount, numericality: { greater_than: 0 }
  validates :payment_method, inclusion: { in: ['Credit Card', 'Cash', 'Check'], message: 'Payment method must be one of the following: Credit Card, Cash, or Check.' }

  # A donation is active if payment has not been received
  # or if it was paid by credit card but the gpo has not been
  # processed.
  def active?(dd_view)
    (payment_received == false || payment_method == 'Credit Card' && gpo_processed == false) && (dd_view || slot.semester == Semester.current_semester)
  end
end
