class Semester < ActiveRecord::Base
  has_many :slots, inverse_of: :semester
  validates :year, :month, :goal, presence: true
  validates :month, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 12 }
  validates :year, :goal, numericality: { greater_than_or_equal_to: 1 }

  def self.current_semester
    year = maximum(:year)
    month = maximum(:month)
    where(year: year, month: month)[0]
  end

  def name
    "#{year}/#{month < 10 ? "0#{month}" : month}"
  end

  def totals
    Rails.cache.fetch "semester_totals/#{self.name}/#{Donation.last.created_at}" do
      donations = Donation.for_semester(self).non_underwriting
      total_progress = donations.sum(:amount)
      total_percent = 100 * (total_progress / goal)

      unpaid_donations = donations.unpaid
      unpaid_progress = unpaid_donations.sum(:amount)
      unpaid_pledgers = donations_to_pledgers_and_totals(unpaid_donations, false)

      paid_donations = donations.paid
      paid_progress = paid_donations.sum(:amount)
      paid_pledgers = donations_to_pledgers_and_totals(paid_donations, true)
      if total_progress.zero?
        paid_percent = 0
      else
        paid_percent = 100 * (paid_progress / total_progress)
      end
      { donations: donations,
        total_progress: total_progress,
        total_percent: total_percent,
        unpaid_progress: unpaid_progress,
        unpaid_pledgers: unpaid_pledgers,
        paid_progress: paid_progress,
        paid_pledgers: paid_pledgers,
        paid_percent: paid_percent
      }
    end
  end

  private
  # Process a list of donations into a list of hashes
  # { :pledger => <Pledger>, :amount => 100 }
  def donations_to_pledgers_and_totals(donations, received)
    donations.map { |d| d.pledger }
      .uniq
      .map do |pled|
        pledger_total = pled.donations
          .select { |d| d.payment_received == received && d.slot.semester == self }
          .reduce(0) { |sum, don| sum + don.amount }
        { pledger: pled, amount: pledger_total }
      end
      .sort_by { |x| x[:amount] }.reverse
  end
end

MONTHS = %w(January February March April May June July 
August September October November December)

