class Reward < ActiveRecord::Base
  belongs_to :pledger
  belongs_to :item
  attr_accessible :comment, :premia_sent, :item, :taxed

  scope :taxed, -> { where taxed: true }
  scope :untaxed, -> { where taxed: false }
end
