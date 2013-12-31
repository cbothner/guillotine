class Comment < ActiveRecord::Base
  belongs_to :show
  belongs_to :pledger
end
