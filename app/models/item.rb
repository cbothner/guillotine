class Item < ActiveRecord::Base
  has_many :rewards, :inverse_of => :item
  has_many :pledgers, :through => :rewards
  attr_accessible :backorderable, :cost, :name, :note, :shape, :stock, :taxable_value

  validates :cost, :name, :shape, :stock, :taxable_value, :presence => true
  validates :cost, :taxable_value, :numericality => { :greater_than => 0 }
  validates :cost, :numericality => { :greater_than => :taxable_value, :message => "The item's cost must be greater than its taxable value." }
  validates :stock, :numericality => { :only_integer => true, :greater_than => 0 }
  validates :shape, :inclusion => { :in => %w{box flat shirt sweatshirt incorporeal}, :message => "Must be a valid shape" }
end
