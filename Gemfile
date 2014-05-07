source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.0'
gem 'webrick', '1.3.1'

gem 'cache_digests'

# Use sqlite3 as the database for Active Record
gem 'sqlite3'
gem 'mysql2'
gem 'devise', '3.0.0.rc'
gem 'nokogiri'
gem 'yaml_db', github: 'jetthoughts/yaml_db', ref: 'fb4b6bd7e12de3cffa93e0a298a1e5253d7e92ba'
gem 'protected_attributes'
gem 'colorize'
# See https://github.com/sstephenson/execjs #readme for more supported runtimes
gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# gem 'dynatree-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

gem 'database_cleaner'
gem 'rinruby'
group :development, :test do
   gem 'factory_girl_rails', :require => false
   gem 'webrat'
   gem 'rspec-rails'
   gem "autotest"
   gem 'seed_dump'
end

group :test do 
  gem 'cucumber-rails', :require => false
  gem 'factory_girl_rails', :require => false
	gem 'faker'
	gem 'capybara'
	gem 'guard-rspec'
	gem 'launchy'
  gem 'seed_dump'
  gem 'selenium-webdriver'
  gem "codeclimate-test-reporter", require: nil
end

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

# Use ActiveModel has_secure_password
 gem 'bcrypt-ruby', '~> 3.0.0'

group :assets do
  # Use SCSS for stylesheets
  gem 'sass-rails', '~> 4.0.0'
  # Use Uglifier as compressor for JavaScript assets
  gem 'uglifier', '>= 1.3.0'

  # Use CoffeeScript for .js.coffee assets and views
  gem 'coffee-rails', '~> 4.0.0'

end 
# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]
