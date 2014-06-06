class Pledger < ActiveRecord::Base
  def self.select_with_args(sql, args)
    query = sanitize_sql_array([sql, args].flatten)
    select(query)
  end

  has_many :donations, inverse_of: :pledger
  has_many :forgiven_donations, inverse_of: :pledger
  has_many :slots, through: :donations
  has_many :shows, through: :slots
  has_many :rewards, inverse_of: :pledger
  has_many :items, through: :rewards
  has_many :comments
  attr_accessible :affiliation, :email, :individual, :name, :local_address, :local_address2, :local_city, :local_phone, :local_state, :local_zip, :perm_address, :perm_address2, :perm_city, :perm_country, :perm_phone, :perm_state, :perm_zip

  validates :name, :perm_address, :perm_city, :perm_country, :perm_phone, presence: true
  validates :affiliation, inclusion: { in: %w(Staff Alumni Public), message: 'Affiliation must be one of staff, alumni, or public' }
  with_options if: :american? do |american|
    american.validates :perm_state, presence: true, length: { is: 2 }
    american.validates :perm_zip, presence: true, numericality: { only_integer: true }, length: { is: 5 }
  end
  with_options if: :diff_local? do |local|
    local.validates :local_state, :local_city, :local_phone, :local_zip, presence: true
    local.validates :local_state, length: { is: 2 }
    local.validates :local_zip, numericality: { only_integer: true }, length: { is: 5 }
  end

  def american?
    :perm_country == 'USA'
  end

  def diff_local?
    :local_address.blank?
  end
end
