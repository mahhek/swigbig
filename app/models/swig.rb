class Swig < ActiveRecord::Base
  belongs_to :user
  belongs_to :bar
  
  with_options :dependent => :destroy do |reward|
    has_many :rewards, :class_name => "UserReward"
    has_many :shared_rewards
  end

  validates :user_id, :presence => true
  validates :bar_id, :presence => true
  validates :reward_point, :presence => true
  validates :bar_id, :uniqueness => {:scope => :user_id}

  after_save :activate_bar_deal, :get_my_popularity_reward

  def get_my_popularity_reward
    notifier = Notification.where(bar_id: self.bar_id).first
    unless notifier.nil?
      notifications = Notification.where(notifier_type: "User", notifier_id: notifier.notifier_id, bar_id: self.bar_id, notifiable_type: "User")
      unless notifications.blank?
        swigs_total = Swig.count(:conditions => ["user_id IN (?) AND bar_id = ?", notifications.map(&:notifiable_id), self.bar_id])
        if swigs_total > 0
          bar = Bar.find self.bar_id
          if bar
            inviter_swig = Swig.where(user_id: notifier.notifier_id, bar_id: self.bar_id).first
            bar.bar_rewards.each do |bar_reward|
              if bar_reward.reward.reward_point <= swigs_total and bar_reward.reward.reward_class.name.eql?("Popularity")
                previous_popularity_rewards = UserReward.where(swig_id: inviter_swig.id, recipient_id: nil)
                previous_reward = nil
                previous_popularity_rewards.each do |previous_popularity_reward|
                  previous_reward = previous_popularity_reward if previous_popularity_reward.reward.reward_class.name.eql?("Popularity")
                end
                unless previous_reward.nil?
                  previous_reward.reward_id = bar_reward.reward_id
                  previous_reward.save :validate => false
                else
                  UserReward.create(reward_id: bar_reward.reward_id, swig_id: inviter_swig.id, total: 1)
                end
                user_notifier = User.find notifier.notifier_id
                reward_notification = user_notifier.notifications.new(description: "You have got #{bar_reward.reward.name} from bar #{bar.name}")
                reward_notification.save
              end
            end
          end
        end
      end
    end
  end

  def activate_bar_deal
    self.bar.bar_deals.where(is_active: false).each do |bar_deal|
      if bar_deal.deal.tipping_points <= self.reward_point
        bar_deal.is_active = true
        bar_deal.opened_count += 1
        bar_deal.save :validate => false
      end
    end
  end

  def give_reward
    bar_rewards = BarReward.where(bar_id: self.bar_id)
    reached_last_reward = nil
    reward_id = 0
    reward_point = 0
    bar_rewards.each do |bar_reward|
      if bar_reward.reward.reward_point <= self.reward_point and bar_reward.reward.reward_class.name.eql?("Loyalty")
        reached_last_reward = true
        if reward_point <= bar_reward.reward.reward_point
          reward_id = bar_reward.reward.id
          reward_point = bar_reward.reward.reward_point
        end
      elsif bar_reward.reward.reward_class.name.eql?("Loyalty")
        reached_last_reward = false
        break
      end
    end

    user_empty_reward = self.rewards.where(reward_id: 0, recipient_id: nil).first
    if reached_last_reward.eql?(true)
      user_reward = self.rewards.where(reward_id: reward_id, recipient_id: nil).first
      if user_reward.nil? and user_empty_reward.nil?
        UserReward.create(:reward_id => reward_id, :total => 1, :earned => 0, :swig_id => self.id)
      else
        if user_reward
          user_reward.total = user_reward.total + 1
          user_reward.save :validate => false
        elsif user_empty_reward
          user_empty_reward.reward_id = reward_id
          user_empty_reward.total = 1
          user_empty_reward.save :validate => false
        end
      end
      self.reward_point = self.reward_point - reward_point
      self.save :validate => false
    elsif reached_last_reward.eql?(false) and user_empty_reward.nil? and !reward_point.eql?(0)
      UserReward.create(:reward_id => 0, :total => 0, :earned => 0, :swig_id => self.id)
    end
  end

  def update_swigging
    self.reward_point = self.reward_point + 1
    self.save :validate => false
  end

  def self.get_top_ten_swigers
    date_today = Date.today
    top_ten_swigs = Swig.where(["updated_at BETWEEN ? AND ?", date_today.strftime("%Y-%m-%d 00:00:00"), date_today.strftime("%Y-%m-%d 23:59:59")]).order("updated_at DESC").limit(10)
  end

  def self.create_swigging(user_id, bar_id)
    swig = Swig.new(
      user_id: user_id,
      bar_id: bar_id,
      reward_point: 1
    )
    swig.save :validate => false
  end

  def update_status
    status = Status.new(
      user_id: self.user_id,
      body: "checkin on #{self.bar.name}"
    )
    status.save :validate => false
  end

  def self.get_total_user_per_weekly_swig(swigs)
    date_today = Date.today
    number_of_day = date_today.strftime("%u").to_i
    case number_of_day
    when 1
      start_day_of_the_week = date_today
      end_day_of_the_week = date_today + 5.days
    when 2
      start_day_of_the_week = date_today.yesterday
      end_day_of_the_week = date_today + 4.days
    when 3
      start_day_of_the_week = date_today - 2.days
      end_day_of_the_week = date_today + 3.days
    when 4
      start_day_of_the_week = date_today - 3.days
      end_day_of_the_week = date_today + 2.days
    when 5
      start_day_of_the_week = date_today - 4.days
      end_day_of_the_week = date_today + 1.days
    when 6
      start_day_of_the_week = date_today - 5.days
      end_day_of_the_week = date_today
    else
      start_day_of_the_week = date_today - 6.days
      end_day_of_the_week = date_today - 1.day
    end
    swigs.count(:conditions => ["updated_at BETWEEN ? AND ?", start_day_of_the_week.strftime("%Y-%m-%d 00:00:00"), end_day_of_the_week.strftime("%Y-%m-%d 23:59:59")])
  end
end
# == Schema Information
#
# Table name: swigs
#
#  id         :integer(4)      not null, primary key
#  user_id    :integer(4)
#  bar_id     :integer(4)
#  created_at :datetime
#  updated_at :datetime
#

