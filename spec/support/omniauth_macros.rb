module OmniauthMacros
  def mock_auth_hash
    # The mock_auth configuration allows you to set per-provider (or default)
    # authentication hashes to return during integration testing.
    OmniAuth.config.mock_auth[:github] = {
      'provider' => 'github',
      'uid' => '123545',
      'info' => {
        'name' => 'mockuser',
        'image' => 'mock_user_thumbnail_url',
        'email' => 'mock_user@gmail.com'

      },
      'credentials' => {
        'token' => 'mock_token',
        'secret' => 'mock_secret'
      }
    }

    OmniAuth.config.mock_auth[:facebook] = {
      'provider' => 'github',
      'uid' => '123545',
      'info' => {
        'name' => 'mockuser',
        'image' => 'mock_user_thumbnail_url',
        'email' => 'mock_user@gmail.com'

      },
      'credentials' => {
        'token' => 'mock_token',
        'secret' => 'mock_secret'
      }
    }
  end
end
