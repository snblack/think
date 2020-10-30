class OauthCallbacksController < Devise::OmniauthCallbacksController
    def github
      autorize('GitHub')
    end

    def facebook
      autorize('Facebook')
    end

    private

    def autorize(kind)
      @user = User.find_for_oauth(request.env['omniauth.auth'])

      if @user&.persisted?
        sign_in_and_redirect @user, event: :authentication
        set_flash_message(:notice, :success, kind: kind) if is_navigational_format?
      else
        redirect_to root_path, alert: 'Something went wrong'
      end
    end

end
