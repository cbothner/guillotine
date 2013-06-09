class Reward < ActiveRecord::Base
  belongs_to :pledger
  belongs_to :item
  attr_accessible :comment, :premia_sent
end
