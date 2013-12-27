class Slot < ActiveRecord::Base
  has_many :donations, :inverse_of => :slot
  has_many :pledgers, :through => :donations
  belongs_to :show, :inverse_of => :slots
  attr_accessible :end, :semester, :start, :weekday

  validates  :end, :semester, :start, :weekday, :presence => true
  validates :weekday, :numericality => { :less_than_or_equal => 6, :greater_than_or_equal => 0, :only_integer => true } # The week starts with Monday = 0
  validates :semester, :numericality => { :greater_than => 0 }

  def self.on_now
    now = Time.new
    weekday = now.wday == 0 ? 6 : now.wday - 1
    std_now = Time.utc(2000,1,1,now.hour,now.min)
    Slot.where("weekday = :weekday and start <= :now and \"end\" > :now and semester = :semester", {weekday: weekday, now: std_now, semester: Slot.current_semester})
  end

  def self.for_select #TODO takes a semester argument
    Slot.where(:semester => Slot.current_semester)
        .order(:weekday,:start)
        .group_by(&:weekday)
        .inject({}) do |r,e|
          r[Weekdays[e.first]] = e.last.map{|s| [s.show.get_name, s.id]}
          r
        end
    #{
      #'Monday'    => where(:weekday => 0).order(:start).map { |s| [s.show.get_name, s.id] },
      #'Tuesday'   => where(:weekday => 1).order(:start).map { |s| [s.show.get_name, s.id] },
      #'Wednesday' => where(:weekday => 2).order(:start).map { |s| [s.show.get_name, s.id] },
      #'Thursday'  => where(:weekday => 3).order(:start).map { |s| [s.show.get_name, s.id] },
      #'Friday'    => where(:weekday => 4).order(:start).map { |s| [s.show.get_name, s.id] },
      #'Saturday'  => where(:weekday => 5).order(:start).map { |s| [s.show.get_name, s.id] },
      #'Sunday'    => where(:weekday => 6).order(:start).map { |s| [s.show.get_name, s.id] }
    #}
  end
  def self.current_semester
    self.maximum(:semester)
  end
end

Weekdays = {
  'Monday' => 0, 'Tuesday' => 1, 'Wednesday' => 2, 'Thursday' => 3,
  "Friday" => 4, "Saturday" => 5, 'Sunday' => 6,
  0 => 'Monday', 1 => 'Tuesday', 2 => 'Wednesday', 3 => 'Thursday',
  4 => 'Friday', 5 => 'Saturday', 6 => 'Sunday'
}
