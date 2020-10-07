class RewardsController < ApplicationController
  def index
    @rewards = Reward.includes(:user).where("user_id = ?", current_user)

  end
end
