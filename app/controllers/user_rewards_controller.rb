class UserRewardsController < ApplicationController
  before_filter :authenticate_user!

  def rewards
    @unclaimed_rewards = current_user.rewards.where("reward_id <> 0 AND earned < total AND recipient_id IS NULL").order("created_at DESC")
    @earned_rewards = current_user.rewards.where("reward_id <> 0 AND earned > 0 AND recipient_id IS NULL").order("created_at DESC")
    @unclaimed_rewards << UserReward.where(["reward_id <> 0 AND earned < total AND recipient_id = ?", current_user.id]).order("created_at DESC")
    @earned_rewards << UserReward.where(["reward_id <> 0 AND earned > 0 AND recipient_id = ?", current_user.id]).order("created_at DESC")
    @unclaimed_rewards.flatten!
    @earned_rewards.flatten!
    session[:button] = "reward"
  end

  def show
    if params[:claimed].eql?("true")
      @earned_reward = UserReward.find(params[:id])
    elsif params[:claimed].eql?("false")
      @unclaimed_reward = UserReward.find(params[:id])
    end
  end

end
