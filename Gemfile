source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.2'

gem 'rails', '~> 6.0.3', '>= 6.0.3.2'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 4.1'
gem 'sass-rails', '>= 6'
gem 'webpacker', '~> 4.0'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.7'
gem 'devise'
gem "cocoon"
gem 'omniauth'
gem 'omniauth-github'
gem 'omniauth-facebook'
gem 'cancancan'

gem 'bootsnap', '>= 1.4.2', require: false
gem "slim-rails"
gem 'jquery-rails'
gem "aws-sdk-s3", require: false
gem "octokit", "~> 4.0"
gem 'gon'
gem 'handlebars-source', '~> 4.7', '>= 4.7.6'
gem 'doorkeeper'
gem 'active_model_serializers', '~> 0.10'
gem 'oj'

#ActiveJobs
gem 'sidekiq'
gem 'sinatra', require: false
gem 'whenever', require: false

#search
gem 'mysql2'
gem 'thinking-sphinx'
gem 'mini_racer'

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rspec-rails', '~> 4.0.1'
  gem 'factory_bot_rails'
  gem 'rails-controller-testing'
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'capistrano', '~> 3.0'
  gem 'capistrano-rvm', require: false
  gem "capistrano-rails", "~> 1.3", require: false
end

group :test do
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  gem 'webdrivers'
  gem 'shoulda-matchers', '~> 4.0'
  gem 'rails-controller-testing'
  gem 'launchy'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
