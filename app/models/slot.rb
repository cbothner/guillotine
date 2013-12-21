class Slot < ActiveRecord::Base
  has_many :donations, :inverse_of => :slot
  has_many :pledgers, :through => :donations
  belongs_to :show, :inverse_of => :slots
  attr_accessible :end, :semester, :start, :weekday

  validates  :end, :semester, :start, :weekday, :presence => true
  validates :weekday, :numericality => { :less_than_or_equal => 6, :greater_than_or_equal => 0, :only_integer => true } # The week starts with Monday = 0
  validates :semester, :numericality => { :greater_than => 0 }

  def self.for_select #TODO takes a semester argument
    {
      'Monday'    => where(:weekday => 0).order(:start).map { |s| [s.show.dj.empty? ? s.show.name : "#{s.show.name} with #{s.show.dj}", s.id] },
      'Tuesday'   => where(:weekday => 1).order(:start).map { |s| [s.show.dj.empty? ? s.show.name : "#{s.show.name} with #{s.show.dj}", s.id] },
      'Wednesday' => where(:weekday => 2).order(:start).map { |s| [s.show.dj.empty? ? s.show.name : "#{s.show.name} with #{s.show.dj}", s.id] },
      'Thursday'  => where(:weekday => 3).order(:start).map { |s| [s.show.dj.empty? ? s.show.name : "#{s.show.name} with #{s.show.dj}", s.id] },
      'Friday'    => where(:weekday => 4).order(:start).map { |s| [s.show.dj.empty? ? s.show.name : "#{s.show.name} with #{s.show.dj}", s.id] },
      'Saturday'  => where(:weekday => 5).order(:start).map { |s| [s.show.dj.empty? ? s.show.name : "#{s.show.name} with #{s.show.dj}", s.show.id] },
      'Sunday'    => where(:weekday => 6).order(:start).map { |s| [s.show.dj.empty? ? s.show.name : "#{s.show.name} with #{s.show.dj}", s.id] }
    }
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
