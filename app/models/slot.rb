class Slot < ActiveRecord::Base
  has_many :donations, :inverse_of => :slot
  has_many :pledgers, :through => :donations
  belongs_to :show
  attr_accessible :end, :semester, :start, :weekday

  validates  :end, :semester, :start, :weekday, :presence => true
  validates :weekday, :numericality => { :less_than_or_equal => 6, :greater_than_or_equal => 0, :only_integer => true } # The week starts with Monday = 0
  validates :semester, :numericality => { :only_integer => true, :greater_than => 0 }

  def self.for_select
    {
      'Monday'    => where(:weekday => 0).order(:start).map { |s| [s.dj.empty? ? s.name : "#{s.name} with #{s.dj}", s.id] },
      'Tuesday'   => where(:weekday => 1).order(:start).map { |s| [s.dj.empty? ? s.name : "#{s.name} with #{s.dj}", s.id] },
      'Wednesday' => where(:weekday => 2).order(:start).map { |s| [s.dj.empty? ? s.name : "#{s.name} with #{s.dj}", s.id] },
      'Thursday'  => where(:weekday => 3).order(:start).map { |s| [s.dj.empty? ? s.name : "#{s.name} with #{s.dj}", s.id] },
      'Friday'    => where(:weekday => 4).order(:start).map { |s| [s.dj.empty? ? s.name : "#{s.name} with #{s.dj}", s.id] },
      'Saturday'  => where(:weekday => 5).order(:start).map { |s| [s.dj.empty? ? s.name : "#{s.name} with #{s.dj}", s.id] },
      'Sunday'    => where("weekday = 6 and name != 'ALL FREEFORM'").order(:start).map { |s| [s.dj.empty? ? s.name : "#{s.name} with #{s.dj}", s.id] }
    }
  end
end
