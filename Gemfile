source 'https://rubygems.org'

ruby '>=2.4.2', '<=2.5.99'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'bootsnap', require: false
gem 'bootstrap-sass', '~> 3.0'
gem 'coffee-rails', '~> 4.2'
gem 'devise'
gem 'devise-guests', '~> 0.6'
gem 'dotenv-rails'
gem 'hydra-role-management'
gem 'hyrax', '3.0.0-beta1'
gem 'jbuilder', '~> 2.5'
gem 'jquery-rails'
gem 'mysql2', '~> 0.5'
gem 'noid-rails'
gem 'omniauth-shibboleth', '~> 1.3'
gem 'puma', '~> 3.7'
gem 'rails', '~> 5.1'
gem 'riiif', '~> 2.0'
gem 'rsolr', '>= 1.0'
gem 'sass-rails', '~> 5.0'
gem 'sidekiq', '~> 5.2'
gem 'turbolinks', '~> 5'
gem 'twitter-typeahead-rails', '0.11.1.pre.corejavascript'
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby] # Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'uglifier', '>= 1.3.0'
gem 'webpacker', '~> 4.x'
gem 'zizia', '~> 2.1.0.alpha.04'
group :development do
  gem "capistrano", "~> 3.11", require: false
  gem 'capistrano-bundler', '~> 1.3'
  gem 'capistrano-ext'
  gem 'capistrano-passenger'
  gem 'capistrano-rails'
  gem 'capistrano-rails-collection'
  gem 'capistrano-sidekiq', '~> 0.20.0'
  gem 'fcrepo_wrapper'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'solr_wrapper', '>= 0.3'
  gem 'web-console', '>= 3.3.0'
  gem 'xray-rails'
end

group :development, :test do
  gem 'bixby' # bixby = rubocop rules for Hyrax apps
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw] unless ENV['CI'] # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'capybara', '~> 2.13'
  gem 'coveralls', require: false
  gem 'database_cleaner'
  gem 'factory_bot_rails', '~> 4.11.1'
  gem 'ffaker'
  gem 'pry' unless ENV['CI']
  gem 'pry-byebug' unless ENV['CI']
  gem 'rspec-its'
  gem 'rspec-rails'
  gem 'sqlite3', '~> 1.3.7'
  gem 'webdrivers', '~> 3.0'
end

group :test do
  gem 'rspec_junit_formatter'
end
