class SharedRewardsController < ApplicationController
  def share
    errors = []

    errors << "Required share total" if params[:share_total].blank?
    errors << "Required friend" if params[:share_to].blank?
    errors << "Share total over quota" if params[:share_total] and (params[:share_total].to_i > params[:total_unclaimed].to_i)
    errors << "Share total can't zero" if params[:share_total] and (params[:share_total].to_i < 1)

    if errors.blank?
      user_reward = UserReward.find(params[:user_reward_id])

      shared_reward = SharedReward.where(reward_id: user_reward.reward_id, swig_id: user_reward.swig_id, recipient_id: params[:share_to]).first
      if shared_reward
        shared_reward.total = shared_reward.total + params[:share_total].to_i
      else
        shared_reward = SharedReward.new(reward_id: user_reward.reward_id,
          earned: 0, swig_id: user_reward.swig_id,
          total: params[:share_total], recipient_id: params[:share_to])
      end

      if shared_reward.save
        user_reward.total = user_reward.total - params[:share_total].to_i
        user_reward.save :validate => false
        redirect_to rewards_user_rewards_path, notice: 'Reward was successfully shared.'
      else
        errors = shared_reward.errors.full_messages
        flash[:errors] = errors
        redirect_to user_reward_url(params[:user_reward_id], :claimed => false)
      end
    else
      flash[:errors] = errors
      redirect_to user_reward_url(params[:user_reward_id], :claimed => false)
    end
  end
end
