module Bars::DashboardHelper
  def is_bar_have_deal_not_notification_yet?(bar)
    bar.bar_deals.where(is_active: true, is_notification: false)
  end

  def already_notified(bar_deals)
    bar_deals.each do |bar_deal|
      bar_deal.is_notification = true
      bar_deal.save :validate => false
    end
  end
end
