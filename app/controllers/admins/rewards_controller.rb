class Admins::RewardsController < ApplicationController
  layout 'admins'

  before_filter :authenticate_admin!

  before_filter :find_reward, :only => [:show, :edit, :update, :destroy]

  def index
    @rewards = Reward.where(is_admin: true)
    session[:button] = "rewards"
  end

  def show
  end

  def new
    @reward_classes = RewardClass.all
    @reward = Reward.new
  end

  def edit
    @reward_classes = RewardClass.all
  end

  def create
    @reward = Reward.new(params[:reward])
    @reward.is_admin = true

    if @reward.save
      redirect_to admins_reward_path(@reward), notice: 'Reward was successfully created.'
    else
      @reward_classes = RewardClass.all
      render action: "new"
    end
  end

  def update
    if @reward.update_attributes(params[:reward])
      redirect_to admins_reward_path(@reward), notice: 'Reward was successfully updated.'
    else
      @reward_classes = RewardClass.all
      render action: "edit"
    end
  end

  def destroy
    @reward.destroy
    redirect_to admins_rewards_url
  end

  private

  def find_reward
    @reward = Reward.find(params[:id])
  end
end
