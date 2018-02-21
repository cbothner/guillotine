class Semester < ActiveRecord::Base
  has_many :slots, inverse_of: :semester
  has_many :donations, through: :slots
  has_many :pledgers, -> { distinct }, through: :donations

  validates :year, :month, :goal, presence: true
  validates :month, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 12 }
  validates :year, :goal, numericality: { greater_than_or_equal_to: 1 }

  def self.current_semester
    order(year: :desc, month: :desc).first
  end

  def name
    "#{year}/#{month < 10 ? "0#{month}" : month}"
  end
end

MONTHS = %w(January February March April May June July
August September October November December)
