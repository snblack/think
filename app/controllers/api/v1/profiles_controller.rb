class Api::V1::ProfilesController < Api::V1::BaseController
  authorize_resource class: User

  def me
    render json: current_resource_owner
  end

  def index
    @users_without_me = User.where.not(id: current_resource_owner.id)
    render json: @users_without_me
  end
end
