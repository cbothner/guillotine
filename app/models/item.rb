class Item < ActiveRecord::Base
  has_many :rewards, inverse_of: :item
  has_many :pledgers, through: :rewards
  attr_accessible :backorderable, :cost, :name, :note, :shape, :stock, :taxable_value

  validates :cost, :name, :shape, :stock, :taxable_value, presence: true
  validates :cost, :taxable_value, numericality: { greater_than_or_equal: 0 }  # cost = 0 means item is not for sale
  validates :stock, numericality: { only_integer: true, greater_than_or_equal: 0 }
  validates :shape, inclusion: { in: %w(box flat shirt sweatshirt incorporeal), message: 'Must be a valid shape' }

  def self.for_select(total_donation)
    # total_donation = 1_000_000 if user_is_dd?
    active.sort_by { |i| i.cost }.reject { |i| i.cost > total_donation }
      .map { |i| [i, i.get_stock] }
      .map do |i, numleft|
      [i.name + (numleft > 0 ? " — #{numleft} left" : ' — Backordered') + ' ($%.2f)' % i.cost, i.id]
    end
  end

  def self.active
    where("(backorderable = 't' or stock > 0) and cost > 0").order(:name)
      .reject { |i| i.get_stock <= 0 }
  end
  def self.inactive
    where("(backorderable = 'f' and stock <= 0) or cost = 0").order(:name)
  end

  def get_stock
    stock - rewards.where("premia_sent = 'false'").count
  end
end
