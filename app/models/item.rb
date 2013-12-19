class Item < ActiveRecord::Base
  has_many :rewards, :inverse_of => :item
  has_many :pledgers, :through => :rewards
  attr_accessible :backorderable, :cost, :name, :note, :shape, :stock, :taxable_value

  validates :cost, :name, :shape, :stock, :taxable_value, :presence => true
  validates :cost, :taxable_value, :numericality => { :greater_than => 0 }
  validates :cost, :numericality => { :greater_than => :taxable_value, :message => "The item's cost must be greater than its taxable value." }
  validates :stock, :numericality => { :only_integer => true, :greater_than_or_equal => 0 }
  validates :shape, :inclusion => { :in => %w{box flat shirt sweatshirt incorporeal}, :message => "Must be a valid shape" }

  def self.for_select
    not_sold_out = []
    order(:cost).each { |i| 
      numleft = i.stock - i.rewards.where("premia_sent = 'false'").count
      not_sold_out.push([i,numleft]) if numleft > 0 or i.backorderable
    }
    not_sold_out.map { |i,numleft|
      [i.name + (numleft > 0 ? " — #{numleft} left" : " — Backordered") + " ($%.2f)" % i.cost, i.id]
    }
    # TODO Only show things that Pledger can afford in the non-DD view
  end
end
