class RewardsController < ApplicationController
  def index
    # @rewards = Reward.includes(:user).where("user_id = ?", current_user)
    @rewards = Reward.where(user: current_user).includes(:question)
  end
end
