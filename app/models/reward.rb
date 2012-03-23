class Reward < ActiveRecord::Base
  belongs_to :reward_class
  belongs_to :deal_type
  with_options :dependent => :destroy do |reward|
    has_many :bar_rewards
    has_many :user_rewards
    has_many :shared_rewards
  end

  validates :name, :presence => true
#  validates :description, :presence => true
#  validates :reward_class_id, :presence => true
#  validates :name, :uniqueness => {:scope => :reward_class_id}
#  validates :reward_point, :numericality => true
#  validates :reward_point, :presence => true
#  validate :must_greater_than_zero

  def must_greater_than_zero
    errors.add(:reward_point,"must greater than zero") if !self.reward_point.blank? and self.reward_point < 1
  end
end
