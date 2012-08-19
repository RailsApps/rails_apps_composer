# Application template recipe for the rails_apps_composer. Change the recipe here:
# https://github.com/RailsApps/rails_apps_composer/blob/master/recipes/gems.rb

### GEMFILE ###

## Ruby on Rails
insert_into_file 'Gemfile', "ruby '1.9.3'\n", :before => "gem 'rails', '3.2.6'" if prefer :deploy, 'heroku'

## Web Server
if (prefs[:dev_webserver] == prefs[:prod_webserver])
  gem 'thin', '>= 1.4.1' if prefer :dev_webserver, 'thin'
  gem 'unicorn', '>= 4.3.1' if prefer :dev_webserver, 'unicorn'
  gem 'puma', '>= 1.6.1' if prefer :dev_webserver, 'puma'
else
  gem 'thin', '>= 1.4.1', :group => [:development, :test] if prefer :dev_webserver, 'thin'
  gem 'unicorn', '>= 4.3.1', :group => [:development, :test] if prefer :dev_webserver, 'unicorn'
  gem 'puma', '>= 1.6.1', :group => [:development, :test] if prefer :dev_webserver, 'puma'
  gem 'thin', '>= 1.4.1', :group => :production if prefer :prod_webserver, 'thin'
  gem 'unicorn', '>= 4.3.1', :group => :production if prefer :prod_webserver, 'unicorn'
  gem 'puma', '>= 1.6.1', :group => :production if prefer :prod_webserver, 'puma'
end

## Database Adapter
gsub_file 'Gemfile', /gem 'sqlite3'\n/, '' unless prefer :database, 'sqlite'
gem 'mongoid', '>= 3.0.3' if prefer :orm, 'mongoid'
gem 'pg', '>= 0.14.0' if prefer :database, 'postgresql'
gem 'mysql2', '>= 0.3.11' if prefer :database, 'mysql'

## Template Engine
if prefer :templates, 'haml'
  gem 'haml', '>= 3.1.7'
  gem 'haml-rails', '>= 0.3.4', :group => :development
  # hpricot and ruby_parser are needed for conversion of HTML to Haml
  gem 'hpricot', '>= 0.8.6', :group => :development
  gem 'ruby_parser', '>= 2.3.1', :group => :development
end
if prefer :templates, 'slim'
  gem 'slim', '>= 1.2.2'
  gem 'haml2slim', '>= 0.4.6', :group => :development
  # Haml is needed for conversion of HTML to Slim
  gem 'haml', '>= 3.1.6', :group => :development
  gem 'haml-rails', '>= 0.3.4', :group => :development
  gem 'hpricot', '>= 0.8.6', :group => :development
  gem 'ruby_parser', '>= 2.3.1', :group => :development
end

## Testing Framework
if prefer :unit_test, 'rspec'
  gem 'rspec-rails', '>= 2.11.0', :group => [:development, :test]
  gem 'capybara', '>= 1.1.2', :group => :test
  if prefer :orm, 'mongoid'
    # use the database_cleaner gem to reset the test database
    gem 'database_cleaner', '>= 0.8.0', :group => :test
    # include RSpec matchers from the mongoid-rspec gem
    gem 'mongoid-rspec', '>= 1.4.6', :group => :test
  end
  gem 'email_spec', '>= 1.2.1', :group => :test unless prefer :email, 'none'
end
if prefer :integration, 'cucumber'
  gem 'cucumber-rails', '>= 1.3.0', :group => :test, :require => false
  gem 'database_cleaner', '>= 0.8.0', :group => :test unless prefer :orm, 'mongoid'
  gem 'launchy', '>= 2.1.2', :group => :test
end
gem 'turnip', '>= 1.0.0', :group => :test if prefer :integration, 'turnip'
gem 'factory_girl_rails', '>= 4.0.0', :group => [:development, :test] if prefer :fixtures, 'factory_girl'
gem 'machinist', '>= 2.0', :group => :test if prefer :fixtures, 'machinist'

## Front-end Framework
gem 'bootstrap-sass', '>= 2.0.4.0' if prefer :bootstrap, 'sass'
gem 'compass-rails', '>= 1.0.3', :group => :assets if prefer :frontend, 'foundation'
gem 'zurb-foundation', '>= 3.0.9', :group => :assets if prefer :frontend, 'foundation'
if prefer :bootstrap, 'less'
  gem 'twitter-bootstrap-rails', '>= 2.1.1', :group => :assets
  # install gem 'therubyracer' to use Less
  gem 'therubyracer', '>= 0.10.2', :group => :assets, :platform => :ruby
end

## Email
gem 'sendgrid', '>= 1.0.1' if prefer :email, 'sendgrid'
gem 'hominid', '>= 3.0.5' if prefer :email, 'mandrill'

## Authentication (Devise)
gem 'devise', '>= 2.1.2' if prefer :authentication, 'devise'
gem 'devise_invitable', '>= 1.0.3' if prefer :devise_modules, 'invitable'

## Authentication (OmniAuth)
gem 'omniauth', '>= 1.1.0' if prefer :authentication, 'omniauth'
gem 'omniauth-twitter' if prefer :omniauth_provider, 'twitter'
gem 'omniauth-facebook' if prefer :omniauth_provider, 'facebook'
gem 'omniauth-github' if prefer :omniauth_provider, 'github'
gem 'omniauth-linkedin' if prefer :omniauth_provider, 'linkedin'
gem 'omniauth-google-oauth2' if prefer :omniauth_provider, 'google-oauth2'
gem 'omniauth-tumblr' if prefer :omniauth_provider, 'tumblr'

## Authorization 
if prefer :authorization, 'cancan'
  gem 'cancan', '>= 1.6.8'
  gem 'rolify', '>= 3.2.0'
end

## Signup App 
if prefer :prelaunch_app, 'signup_app'
  gem 'google_visualr', '>= 2.1.2'
  gem 'jquery-datatables-rails', '>= 1.10.0'
end

## Gems from a defaults file or added interactively
gems.each do |g|
  gem g
end

## Git
git :add => '.' if prefer :git, true
git :commit => "-aqm 'rails_apps_composer: Gemfile'" if prefer :git, true

### CREATE DATABASE ###
after_bundler do
  copy_from_repo 'config/database-postgresql.yml', :prefs => 'postgresql'
  copy_from_repo 'config/database-mysql.yml', :prefs => 'mysql'
  generate 'mongoid:config' if prefer :orm, 'mongoid'
  remove_file 'config/database.yml' if prefer :orm, 'mongoid'
  if prefer :database, 'postgresql'
    begin
      say_wizard "Creating a user named '#{app_name}' for PostgreSQL"
      run "createuser #{app_name}" if prefer :database, 'postgresql'
      gsub_file "config/database.yml", /username: .*/, "username: #{app_name}"
      gsub_file "config/database.yml", /database: myapp_development/, "database: #{app_name}_development"
      gsub_file "config/database.yml", /database: myapp_test/,        "database: #{app_name}_test"
      gsub_file "config/database.yml", /database: myapp_production/,  "database: #{app_name}_production"
    rescue StandardError
      raise "unable to create a user for PostgreSQL"
    end
  end
  unless prefer :database, 'sqlite'
    affirm = multiple_choice "Drop any existing databases named #{app_name}?", 
      [["Yes (continue)",true], ["No (abort)",false]]
    if affirm
      run 'bundle exec rake db:drop'
    else
      raise "aborted at user's request"
    end
  end
  run 'bundle exec rake db:create:all' unless prefer :orm, 'mongoid'
  run 'bundle exec rake db:create' if prefer :orm, 'mongoid'
  ## Git
  git :add => '.' if prefer :git, true
  git :commit => "-aqm 'rails_apps_composer: create database'" if prefer :git, true
end # after_bundler

### GENERATORS ###
after_bundler do
  ## Front-end Framework
  generate 'foundation:install' if prefer :frontend, 'foundation'
  ## Git
  git :add => '.' if prefer :git, true
  git :commit => "-aqm 'rails_apps_composer: generators'" if prefer :git, true
end # after_bundler

__END__

name: gems
description: "Add the gems your application needs."
author: RailsApps

requires: [setup]
run_after: [setup]
category: configuration
