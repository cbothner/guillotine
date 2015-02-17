class Item < ActiveRecord::Base
  has_many :rewards, inverse_of: :item
  has_many :pledgers, through: :rewards
  attr_accessible :backorderable, :cost, :name, :note, :shape, :stock, :taxable_value

  validates :cost, :name, :shape, :stock, :taxable_value, presence: true
  validates :cost, :taxable_value, numericality: { greater_than_or_equal: 0 }  # cost = 0 means item is not for sale
  validates :stock, numericality: { only_integer: true, greater_than_or_equal: 0 }
  validates :shape, inclusion: { in: %w(box flat shirt sweatshirt incorporeal), message: 'Must be a valid shape' }

  def self.for_select(total_donation, selected_item = nil)
    affordable = all.select(&:active?)
      .sort_by(&:name)
      .reject{ |i| i.cost > total_donation }
      .map{ |i| [i, i.get_stock] }
    affordable += [[selected_item, selected_item.get_stock + 1]] unless selected_item.nil?
    return affordable.map do |i, numleft|
      numleft_str = if numleft > 0
        "- #{numleft} left"
      else
        "- Made to Order"
      end
      str = i.name + numleft_str + ' ($%.2f)' % i.cost
      [str, i.id]
    end
  end

  def active?
    backorderable || get_stock > 0 && cost > 0
  end
  def inactive?
    !active?
  end

  def get_stock
    stock - rewards.where("premia_sent = 'false'").count
  end
end
