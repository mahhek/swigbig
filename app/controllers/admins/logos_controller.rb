class Admins::LogosController < ApplicationController
  layout 'admins'

  before_filter :authenticate_admin!

  before_filter :find_logo, :only => [:show, :edit, :update, :destroy]

  def index
    @logos = Logo.all
    session[:button] = "logo"
  end

  def show
  end

  def new
    @logo = Logo.new
  end

  def edit
  end

  def create
    @logo = Logo.new(params[:logo])

    if @logo.save
      redirect_to admins_logo_path(@logo), notice: 'Logo was successfully created.'
    else
      render action: "new"
    end
  end

  def update
    if @logo.update_attributes(params[:logo])
      redirect_to admins_logo_path(@logo), notice: 'Logo was successfully updated.'
    else
      render action: "edit"
    end
  end

  def destroy
    @logo.destroy
    redirect_to admins_logos_url
  end

  private

  def find_logo
    @logo = Logo.find(params[:id])
  end
end
