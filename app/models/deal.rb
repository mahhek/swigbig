class Deal < ActiveRecord::Base
  has_many :bar_deals, :dependent => :destroy
  belongs_to :deal_type
#  validates :name, :tier, :tipping_points, :day_of_week, :presence => true
  validates :name,:day_of_week, :presence => true

  TIPPING_POINTS = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]
  DAYS_OF_WEEK = [1,2,3,4,5,6,7]
  TIERS = [1,2,3,4,5]
end
# == Schema Information
#
# Table name: deals
#
#  id             :integer(4)      not null, primary key
#  name           :string(255)
#  tier           :integer(4)
#  tipping_points :integer(4)
#  day_of_week    :integer(4)
#  created_at     :datetime
#  updated_at     :datetime
#

