class Admins::BarsController < ApplicationController
  layout 'admins'

  before_filter :authenticate_admin!

  before_filter :find_bar, :except => [:index, :new, :create]
  
  def index
    @bars = Bar.all
    session[:button] = "bar"
  end

  def show
  end

  def new
    @bar = Bar.new
  end

  def edit
  end

  def create
    @bar = Bar.new(params[:bar])

    if @bar.save
      redirect_to admins_bar_path(@bar), notice: 'Bar was successfully created.'
    else
      render action: "new"
    end
  end

  def update
    if @bar.update_attributes(params[:bar])
      redirect_to admins_bar_path(@bar), notice: 'Bar was successfully updated.'
    else
      render action: "edit"
    end
  end

  def destroy
    @bar.destroy
    redirect_to admins_bars_url
  end

  private

  def find_bar
    @bar = Bar.find(params[:id])
  end
end
