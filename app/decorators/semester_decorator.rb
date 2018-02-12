class SemesterDecorator  < Draper::Decorator
  delegate_all

  def donations
    Donation.joins(:slot).where(slots: {semester_id: id})
  end

  def total_progress
    @_total_progress ||= donations.sum :amount
  end

  def total_percent
    total_progress / goal * 100
  end

  def unpaid_progress
    @_unpaid_progress ||= donations.unpaid.sum :amount
  end

  def unpaid_pledgers
    @_unpaid_pledgers ||= totals_by_pledger donations.unpaid
  end

  def paid_progress
    @_paid_progress ||= donations.paid.sum :amount
  end

  def paid_percent
    return 0 if total_progress.zero?
    paid_progress / total_progress * 100
  end

  def paid_pledgers
    @_paid_pledgers ||= totals_by_pledger donations.paid
  end

  def forgiven_donations_total
  @_forgiven_donations_total ||= ForgivenDonation
    .joins(slot: :semester)
    .where(slots: {semester_id: id})
    .sum(:amount)
  end


  private

  def totals_by_pledger(donations)
    donations.group(:pledger).order('sum_amount DESC').sum(:amount)
  end
end
