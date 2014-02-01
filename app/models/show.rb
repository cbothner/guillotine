class Show < ActiveRecord::Base
  has_many :slots, :inverse_of => :show
  has_many :comments
  attr_accessible :dj, :name, :id

  validates :name, :presence => true
  validates :dj, :presence => true, if: :freeform_with?

  def freeform_with?
    name.downcase == "freeform"
  end
  
  def get_name
    freeform_with? ? "Freeform with #{dj}" : name
  end

  def self.for_select(semester = false)
    if semester
      shows = all.order(:name,:dj) & semester.slots.map{|s| s.show}
    else
      shows = all.order(:name,:dj)
    end
    shows.map { |s| [s.get_name, s.id] }
  end

  def self.on_now
    slot_on_now = Slot.on_now
    begin
      slot_on_now.show
    rescue
      0
    end
  end

  def self.on_now_id
    slot_on_now = Slot.on_now
    begin
      slot_on_now.show.id
    rescue
      0
    end
  end
end
