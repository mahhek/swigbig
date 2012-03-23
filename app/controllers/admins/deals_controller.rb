class Admins::DealsController < ApplicationController
  layout 'admins'

  before_filter :authenticate_admin!
  
  before_filter :find_deal, :only => [:show, :edit, :update, :destroy]
  before_filter :load_tipping_points_tiers_and_days_of_week, :only => [:new, :edit, :update, :create]
  
  def index
    @deals = Deal.all
    session[:button] = "deal"
  end

  def show
  end

  def new
    @deal = Deal.new
  end

  def edit
  end

  def create
    @deal = Deal.new(params[:deal])
    @deal.is_admin = true

    if @deal.save
      redirect_to admins_deal_path(@deal), notice: 'Deal was successfully created.'
    else
      render action: "new"
    end
  end

  def update
    if @deal.update_attributes(params[:deal])
      redirect_to admins_deal_path(@deal), notice: 'Deal was successfully updated.'
    else
      render action: "edit"
    end
  end

  def destroy
    @deal.destroy
    redirect_to admin_deals_url
  end

  private

  def find_deal
    @deal = Deal.find(params[:id])
  end

  def load_tipping_points_tiers_and_days_of_week
    @tipping_points = Deal::TIPPING_POINTS
    @days_of_week = Deal::DAYS_OF_WEEK
    @tiers = Deal::TIERS
  end
end
