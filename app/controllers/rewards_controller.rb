class RewardsController < ApplicationController
  authorize_resource
  
  def index
    # @rewards = Reward.includes(:user).where("user_id = ?", current_user)
    @rewards = Reward.where(user: current_user).includes(:question)
  end
end
