class Slot < ActiveRecord::Base
  has_many :donations, inverse_of: :slot, dependent: :restrict_with_error
  has_many :forgiven_donations, inverse_of: :slot, dependent: :restrict_with_error
  has_many :pledgers, through: :donations, dependent: :restrict_with_error
  belongs_to :show, inverse_of: :slots
  belongs_to :semester, inverse_of: :slots
  attr_accessible :end, :semester_id, :start, :weekday

  validates :end, :semester_id, :start, :weekday, presence: true
  validates :weekday, numericality: { less_than_or_equal: 6, greater_than_or_equal: 0, only_integer: true } # The week starts with Monday = 0

  def self.on_now
    now = ActiveSupport::TimeZone["America/New_York"].now
    weekday = now.wday == 0 ? 6 : now.wday - 1
    std_now = Time.new(2000, 1, 1, now.hour, now.min)
    where(semester: Semester.current_semester, weekday: weekday)
    .where('? BETWEEN start AND "end"', std_now)
    .first
  end

  def self.for_select(semester = Semester.current_semester)
    includes(:show)
      .where(semester: semester)
      .order(:weekday, :start)
      .group_by(&:weekday)
      .reduce({}) do |r, e|
        r[Weekdays[e.first]] = e.last.map { |s| [s.show.get_name, s.id] }
        r
      end
  end

  def length
    naive_seconds = self.end - start
    seconds = naive_seconds * (weekday > 3 ? 2 : 1) # Fri, Sat, Sun go twice
    seconds.to_f / 3600 # return hours
  end
end

Weekdays = {
  'Monday' => 0, 'Tuesday' => 1, 'Wednesday' => 2, 'Thursday' => 3,
  'Friday' => 4, 'Saturday' => 5, 'Sunday' => 6,
  0 => 'Monday', 1 => 'Tuesday', 2 => 'Wednesday', 3 => 'Thursday',
  4 => 'Friday', 5 => 'Saturday', 6 => 'Sunday'
}
