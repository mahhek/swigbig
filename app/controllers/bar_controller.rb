class BarController < ApplicationController
  before_filter :authenticate_user!, :except => :bar_details
  before_filter :bar_sub_domain, :only => :bar_details
  layout "bars", :only => :bar_details

  def favourite_bar
    @favourite_bar = Swig.order("reward_point DESC").first
    session[:button] = "favourite"
  end

  def bar_details
    bar_data
    sign_in(@bar)
  end

  def show
    @bar = Bar.find_by_id(params[:id])
    @deals =  @bar.bar_deals.select{|deal1| deal1.deal.day_of_week == 1}
    render :layout => "application"
  end

  private


  def bar_data
    unless current_subdomain
      if params[:deal_id]
        @deal = Deal.find_by_id(params[:deal_id])
        @bar = @deal.bar_deals.first.bar
        @deals = @bar.bar_deals.select{|deal1| deal1.deal.day_of_week == @deal.day_of_week and deal1.is_active == true}
      elsif params[:bar_id]
        @bar = Bar.find_by_id(params[:bar_id])
        @deals = @bar.bar_deals.select{|deal1| deal1.deal.day_of_week == 1 and deal1.is_active == true}
      end
    else
      @bar = Bar.find_by_name(current_subdomain)
      @deals = @bar.bar_deals.select{|deal1| deal1.deal.day_of_week == 1 and deal1.is_active == true}
    end
    default_data(@bar.id)
  end
  
  def default_data(id)
    @bar_deals = BarDeal.where(is_active: true, bar_id: id)
    @cities = Bar.select("city").all
    @top_ten_swigs = Swig.get_top_ten_swigers
  end

  def bar_sub_domain
    if current_subdomain
      @bar = Bar.find_by_name(current_subdomain)
      params[:bar_id] = @bar.id
    end
  end
  
end
