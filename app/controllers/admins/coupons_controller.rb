class Admins::CouponsController < ApplicationController
  layout 'admins'

  before_filter :authenticate_admin!

  before_filter :find_coupon, :only => [:show, :edit, :update, :destroy]

  def index
    @coupons = Coupon.all
    session[:button] = "coupon"
  end

  def show
  end

  def new
    @coupon = Coupon.new

    #populating coupon code with some random string
    @coupon.code = Devise.friendly_token[0,20]
  end

  def edit
  end

  def create
    @coupon = Coupon.new(params[:coupon])

    if @coupon.save
      redirect_to admins_coupon_path(@coupon), notice: 'Coupon was successfully created.'
    else
      render action: "new"
    end
  end

  def update
    if @coupon.update_attributes(params[:coupon])
      redirect_to admins_coupon_path(@coupon), notice: 'Coupon was successfully updated.'
    else
      render action: "edit"
    end
  end

  def destroy
    @coupon.destroy
    redirect_to admins_coupons_url
  end

  private

  def find_coupon
    @coupon = Coupon.find(params[:id])
  end
end
