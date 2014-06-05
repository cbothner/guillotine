class Slot < ActiveRecord::Base
  has_many :donations, :inverse_of => :slot
  has_many :forgiven_donations, :inverse_of => :slot
  has_many :pledgers, :through => :donations
  belongs_to :show, :inverse_of => :slots
  belongs_to :semester, :inverse_of => :slots
  attr_accessible :end, :semester_id, :start, :weekday

  validates  :end, :semester_id, :start, :weekday, :presence => true
  validates :weekday, :numericality => { :less_than_or_equal => 6, :greater_than_or_equal => 0, :only_integer => true } # The week starts with Monday = 0

  def self.on_now
    now = Time.new
    weekday = now.wday == 0 ? 6 : now.wday - 1
    std_now = Time.utc(2000,1,1,now.hour,now.min)
    Semester.current_semester.slots.where("weekday = :weekday and start <= :now and \"end\" > :now", {weekday: weekday, now: std_now})[0]
  end

  def self.for_select(semester = Semester.current_semester)
    semester.slots
        .order(:weekday,:start)
        .group_by(&:weekday)
        .inject({}) do |r,e|
          r[Weekdays[e.first]] = e.last.map{|s| [s.show.get_name, s.id]}
          r
        end
  end
end

Weekdays = {
  'Monday' => 0, 'Tuesday' => 1, 'Wednesday' => 2, 'Thursday' => 3,
  "Friday" => 4, "Saturday" => 5, 'Sunday' => 6,
  0 => 'Monday', 1 => 'Tuesday', 2 => 'Wednesday', 3 => 'Thursday',
  4 => 'Friday', 5 => 'Saturday', 6 => 'Sunday'
}
