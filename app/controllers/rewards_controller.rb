class RewardsController < ApplicationController
  def index
    @rewards = current_user.rewards
  end
end
