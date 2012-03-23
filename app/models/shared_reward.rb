class SharedReward < ActiveRecord::Base
  self.table_name = "user_rewards"

  belongs_to :reward
  belongs_to :swig

  validates :swig_id, :presence => true
  validates :reward_id, :presence => true
  validates :reward_id, :uniqueness => {:scope => [:swig_id, :recipient_id]}
  validates :earned, :numericality => true
  validates :total, :numericality => true
  validates :recipient_id, :presence => true
end
