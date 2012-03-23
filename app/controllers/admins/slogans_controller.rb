class Admins::SlogansController < ApplicationController
  layout 'admins'

  before_filter :authenticate_admin!

  before_filter :find_slogan, :only => [:show, :edit, :update, :destroy]

  def index
    @slogans = Slogan.all
    session[:button] = "slogan"
  end

  def show
  end

  def new
    @slogan = Slogan.new
  end

  def edit
  end

  def create
    @slogan = Slogan.new(params[:slogan])

    if @slogan.save
      redirect_to admins_slogan_path(@slogan), notice: 'Slogan was successfully created.'
    else
      render action: "new"
    end
  end

  def update
    if @slogan.update_attributes(params[:slogan])
      redirect_to admins_slogan_path(@slogan), notice: 'Slogan was successfully updated.'
    else
      render action: "edit"
    end
  end

  def destroy
    @slogan.destroy
    redirect_to admins_slogans_url
  end

  private

  def find_slogan
    @slogan = Slogan.find(params[:id])
  end
end
