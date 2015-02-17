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
  def active?(active_because_dd)
    active_as_credit_card = (payment_method == 'Credit Card' && !gpo_processed)
    active_as_check_or_cash = !payment_received
    active = (active_as_credit_card || active_as_check_or_cash)
    should_display = (active_because_dd || slot.semester == Semester.current_semester)
    return active && should_display
  end
end
