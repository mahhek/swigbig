module DashboardHelper
  def comments_for(status)
    status.comments.recent.limit(10).all
  end

  def is_user_have_popularity_reward_not_notification_yet?(user)
    user.notifications.where(is_notified: false)
  end

  def already_notified(reward_notifies)
    reward_notifies.each do |reward_notify|
      reward_notify.is_notified = true
      reward_notify.save :validate => false
    end
  end
end
