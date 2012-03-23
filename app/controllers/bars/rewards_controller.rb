class Bars::RewardsController < ApplicationController
  layout 'bars'

  before_filter :authenticate_bar!

  before_filter :populate_default_rewards, :only => [:new, :create, :create_from_default_reward, :edit, :update_from_default_reward, :update]
  before_filter :find_reward, :only => [:show, :edit, :update, :destroy, :reward_status, :reward_status_update]

  def new
    @reward_classes = RewardClass.all
    @reward = Reward.new
    @bar_reward = BarReward.new
  end

  def create
    @reward = Reward.new(params[:reward])
    @reward.is_admin = false

    if @reward.save
      BarReward.create(:bar_id => current_bar.id, :reward_id => @reward.id)
      redirect_to "/reward_status?id=#{@reward.id}", notice: 'Reward was successfully created.'
    else
      @reward_classes = RewardClass.all
      @bar_reward = BarReward.new
      render action: "new"
    end
  end

  def index
    @bar_rewards = current_bar.bar_rewards
    session[:button] = "reward"
  end

  def show
  end

  def edit
    @reward_classes = RewardClass.all
    if @reward.is_admin
      @new_reward = Reward.new
      @bar_reward = BarReward.where(["bar_id = ? AND reward_id = ?", current_bar.id, @reward.id]).first
      @default_reward = true
    else
      @bar_reward = BarReward.new
      @default_reward = false
    end
  end

  def update
    if @reward.update_attributes(params[:reward])
      redirect_to bars_reward_path(@reward), notice: 'Reward was successfully updated.'
    else
      @bar_reward = BarReward.new
      @default_reward = false
      @reward_classes = RewardClass.all
      render action: "edit"
    end
  end

  def destroy
    unless @reward.is_admin
      @reward.destroy
    else
      bar_reward = BarReward.where(["bar_id = ? AND reward_id = ?", current_bar.id, @reward.id]).first
      bar_reward.destroy
    end
    redirect_to bars_rewards_path, notice: 'Reward was successfully deleted.'
  end

  def create_from_default_reward
    @bar_reward = BarReward.new(params[:bar_reward])
    @bar_reward.bar_id = current_bar.id
    if @bar_reward.save
      redirect_to bars_reward_path(@bar_reward.reward), notice: 'Reward was successfully created.'
    else
      @reward_classes = RewardClass.all
      @reward = Reward.new
      render action: "new"
    end
  end

  def update_from_default_reward
    if params[:bar_reward]
      if params[:new_reward].blank?
        @bar_reward = BarReward.where(["bar_id = ? AND reward_id = ?", current_bar.id, params[:reward_id]]).first
        if @bar_reward.update_attributes(params[:bar_reward])
          redirect_to bars_reward_path(@bar_reward.reward.id), notice: 'Reward was successfully updated.'
        else
          @reward = Reward.find(params[:reward_id])
          @new_reward = Reward.new
          @default_reward = true
          render action: "edit"
        end
      else
        @bar_reward = BarReward.new(params[:bar_reward])
        @bar_reward.bar_id = current_bar.id
        if @bar_reward.save
          reward = Reward.find params[:reward_id]
          reward.destroy if reward
          redirect_to bars_reward_path(@bar_reward.reward.id), notice: 'Reward was successfully updated.'
        else
          @reward = Reward.find params[:reward_id]
          @default_reward = false
          render action: "edit"
        end
      end
    elsif params[:reward]
      @new_reward = Reward.new(params[:reward])
      @new_reward.is_admin = false

      if @new_reward.save
        bar_reward = BarReward.where(["bar_id = ? AND reward_id = ?", current_bar.id, params[:reward_id]]).first
        bar_reward.destroy if bar_reward
        BarReward.create(:bar_id => current_bar.id, :reward_id => @new_reward.id)
        redirect_to bars_reward_path(@new_reward), notice: 'Reward was successfully updated.'
      else
        @reward = Reward.find(params[:reward_id])
        @bar_reward = BarReward.where(["bar_id = ? AND reward_id = ?", current_bar.id, params[:reward_id]]).first
        @default_reward = true
        render action: "edit"
      end
    else
      @bar_reward = BarReward.where()
    end
  end

  def reward_status
  end

  def reward_status_update
    @reward.bar_rewards.update_all(:is_active => true)
    redirect_to bars_rewards_path
  end

  private

  def find_reward
    @reward = Reward.find(params[:id])
  end

  def populate_default_rewards
    @default_rewards = Reward.where(is_admin: true)
  end

end
