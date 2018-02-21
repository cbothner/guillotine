class Donation < ActiveRecord::Base
  belongs_to :pledger, inverse_of: :donations
  belongs_to :slot, inverse_of: :donations
  attr_accessible :amount, :gpo_processed, :gpo_sent, :payment_method, :payment_received, :pledge_form_sent, :slot_id, :phone_operator, :comment

  validates :amount, :payment_method, presence: true
  validates :amount, numericality: { greater_than: 0 }
  validates :payment_method, inclusion: { in: %w[Cash Check Online] }

  scope :pledge_form_unsent, -> { where pledge_form_sent: false }

  scope :in_cash, -> { where payment_method: 'Cash' }
  scope :by_check, -> { where payment_method: 'Check' }
  scope :online, -> { where payment_method: 'Online' }

  scope :unpaid, -> { where payment_received: false }
  scope :paid, -> { where payment_received: true }

  scope :non_underwriting, -> { joins(:pledger).where pledgers: { underwriting: false } }
  scope :underwriting, -> { joins(:pledger).where pledgers: { underwriting: true } }

  scope :for_semester, ->(semester) { joins(:slot).where slots: { semester_id: semester.id } }

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
