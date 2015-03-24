class Pledger < ActiveRecord::Base
  has_many :donations, inverse_of: :pledger
  has_many :forgiven_donations, inverse_of: :pledger
  has_many :slots, through: :donations
  has_many :shows, through: :slots
  has_many :rewards, inverse_of: :pledger
  has_many :items, through: :rewards
  has_many :comments
  attr_accessible :affiliation, :email, :individual, :name, :local_address,
    :local_address2, :local_city, :local_phone, :local_state, :local_zip,
    :perm_address, :perm_address2, :perm_city, :perm_country, :perm_phone,
    :perm_state, :perm_zip, :underwriting

  validates :name, :perm_address, :perm_city, :perm_country, presence: true
  validates :affiliation, inclusion: {
    in: %w(Staff Alumni Public Family),
    message: 'Affiliation must be one of staff, alumni, family, or public' }
  with_options if: :american? do |american|
    american.validates :perm_state, presence: true, length: { is: 2 }
    american.validates :perm_zip, presence: true,
      numericality: { only_integer: true }, length: { is: 5 }
  end
  with_options if: :diff_local? do |local|
    local.validates :local_state, :local_city, :local_phone, :local_zip,
      presence: true
    local.validates :local_state, length: { is: 2 }
    local.validates :local_zip, numericality: { only_integer: true },
      length: { is: 5 }
  end
  validate :phone_or_email

  def total_donation(dd_view)
    return 1_000_000 if dd_view
    all_donations_amount = donations.select{|d| d.active?(0)}
      .reduce(0) { |sum, don| sum + don.amount }
    all_rewards_cost = rewards.reject { |r| r.premia_sent }
      .reduce(0) { |sum, rew| sum + rew.item.cost }
    all_donations_amount - all_rewards_cost
  end

  def total_donation_in_semester(semester)
    semester = Semester.current_semester if semester.nil?
    donations.select{|d| d.slot.semester == semester}.reduce(0) {
      |sum, don| sum + don.amount }
  end

  def self.select_with_args(sql, args)
    query = sanitize_sql_array([sql, args].flatten)
    select(query)
  end

  def self.per_tier(cutoffs, options={})
    pledgers = all.map{|p| [p, p.total_donation_in_semester(options[:semester])]}
    pledgers.reject!{|p| p[1] == 0}
    pledgers_by_tier = {}
    cutoffs.sort.reverse.each do |c|
      pledgers_by_tier[c] = pledgers.select{|p| p[1] >= c}.map{|x| x[0]}
      pledgers -= pledgers_by_tier[c]
    end
    pledgers_by_tier
  end

  def self.count_per_tier(cutoffs, options={})
    pledgers_by_tier = per_tier(cutoffs, options)
    Hash[*cutoffs.map do |c|
      [c, pledgers_by_tier[c].count]
    end.flatten]
  end

  def contact_info()
    "#{name}, #{total_donation_in_semester nil}, #{email}, #{perm_address}, " +
      "#{perm_address2}, #{perm_city}, #{perm_state}, #{perm_zip}"
  end

  def american?
    :perm_country == 'USA'
  end

  def diff_local?
    :local_address.blank?
  end

  def phone_or_email
    if perm_phone.blank? && email.blank?
      errors.add(:base, "Phone number or email is required")
    end
  end

end
