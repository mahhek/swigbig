class RewardClass < ActiveRecord::Base
  has_many :rewards, :dependent => :destroy
  validates :name, :presence => true
  validates :name, :uniqueness => true
end
