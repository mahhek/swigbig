class UserReward < ActiveRecord::Base
  belongs_to :reward
  belongs_to :swig

  validates :swig_id, :presence => true
  validates :reward_id, :presence => true
  validates :reward_id, :uniqueness => {:scope => :swig_id}

  def self.reset_popularity_reward
    start_time = (Date.today-1).strftime("%Y-%m-%d 00:00:00")
    end_time = (Date.today-1).strftime("%Y-%m-%d 23:59:59")
    Notification.destroy_all(["created_at BETWEEN ? AND ?", start_time, end_time])
    UserReward.where(["recipient_id = NULL AND created_at BETWEEN ? AND ?", start_time, end_time]).each do |user_reward|
      user_reward.destroy if user_reward.reward.reward_class.name.eql?("Popularity")
    end
  end

end
