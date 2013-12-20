class Show < ActiveRecord::Base
  has_many :slots, :inverse_of => :show
  attr_accessible :dj, :name

  validates :name, :presence => true
  validates :dj, :presence => true, if: :freeform_with?

  def freeform_with?
    name.downcase == "freeform"
  end
  
  def get_name
    freeform_with? ? "Freeform with #{dj}" : name
  end
end
