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
end
