class UserPopularity < ActiveRecord::Base
  belongs_to :user
  belongs_to :bar
end
