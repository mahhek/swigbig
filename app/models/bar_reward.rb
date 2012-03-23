class BarReward < ActiveRecord::Base
  belongs_to :bar
  belongs_to :reward

  validates :bar_id, :presence => true
  validates :reward_id, :presence => true
  validates :reward_id, :uniqueness => {:scope => :bar_id}
end
