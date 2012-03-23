class Admins::PaymentGatewaysController < ApplicationController
  layout 'admins'

  before_filter :authenticate_admin!

  before_filter :find_payment_gateway, :only => [:show, :edit, :update, :destroy]

  def index
    @payment_gateways = PaymentGateway.all
    session[:button] = "payment_gateway"
  end

  def show
  end

  def new
    @payment_gateway = PaymentGateway.new
  end

  def edit
  end

  def create
    @payment_gateway = PaymentGateway.new(params[:payment_gateway])

    if @payment_gateway.save
      redirect_to admins_payment_gateway_path(@payment_gateway), notice: 'PaymentGatey was successfully created.'
    else
      render action: "new"
    end
  end

  def update
    if @payment_gateway.update_attributes(params[:payment_gateway])
      redirect_to admins_payment_gateway_path(@payment_gateway), notice: 'PaymentGatey was successfully updated.'
    else
      render action: "edit"
    end
  end

  def destroy
    @payment_gateway.destroy
    redirect_to admins_payment_gateways_url
  end

  private

  def find_payment_gateway
    @payment_gateway = PaymentGateway.find(params[:id])
  end
end
