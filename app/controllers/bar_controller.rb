class BarController < ApplicationController
  before_filter :authenticate_user!, :except => :bar_details unless current_subdomain.nil?

  def favourite_bar
    @favourite_bar = Swig.order("reward_point DESC").first
    session[:button] = "favourite"
  end

  def bar_details
    if params[:deal_id]
      deal_data
    end
    if params[:bar_id]
      bar_data
    end
  end


  private

  def deal_data
    @deal = Deal.find_by_id(params[:deal_id])
    @bar = @deal.bar_deals.first.bar
    @deals = @bar.bar_deals.select{|deal1| deal1.deal.day_of_week == @deal.day_of_week and deal1.is_active == true}
  end
  def bar_data
    @bar = Bar.find_by_id(params[:bar_id])
    @deals = @deals = @bar.bar_deals.select{|deal1| deal1.deal.day_of_week == 1 and deal1.is_active == true}
  end
end
