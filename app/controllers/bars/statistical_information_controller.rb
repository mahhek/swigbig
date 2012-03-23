class Bars::StatisticalInformationController < ApplicationController
  layout 'bars'

  before_filter :authenticate_bar!

  def index
    date_today = Date.today
    @daily_total_swigs = current_bar.swigs.count(:conditions => ["updated_at BETWEEN ? AND ?", date_today.strftime("%Y-%m-%d 00:00:00"), date_today.strftime("%Y-%m-%d 23:59:59")])
    @weekly_total_swigs = Swig.get_total_user_per_weekly_swig(current_bar.swigs)
    @monthly_total_swigs = current_bar.swigs.count(:conditions => ["updated_at BETWEEN ? AND ?", Time.now.beginning_of_month.strftime("%Y-%m-%d %H:%M:%S"), Time.now.end_of_month.strftime("%Y-%m-%d %H:%M:%S")])
    @deal_most_often_get_unlocked = current_bar.bar_deals.first(:order => "opened_count DESC")
    session[:button] = "statistical"
  end
end
