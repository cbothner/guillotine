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

  def self.for_select
    self.where("name != 'ALL FREEFORM'").order(:name,:dj).map { |s| [s.get_name, s.id] }
  end

  def self.on_now
    slot_on_now = Slot.on_now
    if slot_on_now.empty?
      nil
    else
      slot_on_now[0].show
    end
  end

  def self.on_now_id
    slot_on_now = Slot.on_now
    if slot_on_now.empty?
      0
    else
      slot_on_now[0].show.id
    end
  end
end
