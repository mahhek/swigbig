class Admins::RewardClassesController < ApplicationController
  layout 'admins'

  before_filter :authenticate_admin!

  before_filter :find_reward_class, :only => [:show, :edit, :update, :destroy]

  def new
    @reward_class = RewardClass.new
  end

  def create
    @reward_class = RewardClass.new(params[:reward_class])

    if @reward_class.save
      redirect_to admins_reward_class_path(@reward_class), notice: 'Reward class was successfully created.'
    else
      render action: "new"
    end
  end

  def show
  end

  def index
    @reward_classes = RewardClass.all
    session[:button] = "reward_class"
  end

  def edit
  end

  def update
    if @reward_class.update_attributes(params[:reward_class])
      redirect_to admins_reward_class_path(@reward_class), notice: 'Reward class was successfully updated.'
    else
      render action: "edit"
    end
  end

  def destroy
    @reward_class.destroy
    redirect_to admins_reward_classes_url
  end

  private

  def find_reward_class
    @reward_class = RewardClass.find(params[:id])
  end

end
