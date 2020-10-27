class ApplicationController < ActionController::Base
  before_action :gon_user, unless: :devise_controller?

  private
  
  def gon_user
    gon.user_id = current_user.id if current_user
  end

  def after_sign_in_path_for(resource)
      root_path
  end
end
