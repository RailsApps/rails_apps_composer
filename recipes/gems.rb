# Application template recipe for the rails_apps_composer. Change the recipe here:
# https://github.com/RailsApps/rails_apps_composer/blob/master/recipes/gems.rb

### GEMFILE ###

## Ruby on Rails
insert_into_file('Gemfile', "ruby '#{RUBY_VERSION}'\n", :before => /^ *gem 'rails'/, :force => false)

## Web Server
if (prefs[:dev_webserver] == prefs[:prod_webserver])
  add_gem 'thin' if prefer :dev_webserver, 'thin'
  add_gem 'unicorn' if prefer :dev_webserver, 'unicorn'
  add_gem 'puma' if prefer :dev_webserver, 'puma'
else
  add_gem 'thin', :group => [:development, :test] if prefer :dev_webserver, 'thin'
  add_gem 'unicorn', :group => [:development, :test] if prefer :dev_webserver, 'unicorn'
  add_gem 'puma', :group => [:development, :test] if prefer :dev_webserver, 'puma'
  add_gem 'thin', :group => :production if prefer :prod_webserver, 'thin'
  add_gem 'unicorn', :group => :production if prefer :prod_webserver, 'unicorn'
  add_gem 'puma', :group => :production if prefer :prod_webserver, 'puma'
end

## Rails 4.0 attr_accessible Compatibility
add_gem 'protected_attributes' if Rails::VERSION::MAJOR.to_s == "4"

## Database Adapter
gsub_file 'Gemfile', /gem 'sqlite3'\n/, '' unless prefer :database, 'sqlite'
add_gem 'mongoid' if prefer :orm, 'mongoid'
gsub_file 'Gemfile', /gem 'pg'.*/, ''
add_gem 'pg' if prefer :database, 'postgresql'
gsub_file 'Gemfile', /gem 'mysql2'.*/, ''
add_gem 'mysql2' if prefer :database, 'mysql'

## Template Engine
if prefer :templates, 'haml'
  add_gem 'haml-rails'
  add_gem 'html2haml', :group => :development
end
if prefer :templates, 'slim'
  add_gem 'slim'
  add_gem 'haml2slim', :group => :development
  # Haml is needed for conversion of HTML to Slim
  add_gem 'haml-rails', :group => :development
  add_gem 'html2haml', :group => :development
end

## Testing Framework
if prefer :unit_test, 'rspec'
  add_gem 'rspec-rails', :group => [:development, :test]
  add_gem 'capybara', :group => :test if prefer :integration, 'rspec-capybara'
  add_gem 'database_cleaner', :group => :test
  if prefer :orm, 'mongoid'
    add_gem 'mongoid-rspec', :group => :test
  end
  add_gem 'email_spec', :group => :test
end
if prefer :unit_test, 'minitest'
  add_gem 'minitest-spec-rails', :group => :test
  add_gem 'minitest-wscolor', :group => :test
  add_gem 'capybara', :group => :test if prefer :integration, 'minitest-capybara'
end
if prefer :integration, 'cucumber'
  add_gem 'cucumber-rails', :group => :test, :require => false
  add_gem 'database_cleaner', :group => :test unless prefer :unit_test, 'rspec'
  add_gem 'launchy', :group => :test
  add_gem 'capybara', :group => :test
end
add_gem 'turnip', '>= 1.1.0', :group => :test if prefer :integration, 'turnip'
if prefer :continuous_testing, 'guard'
  add_gem 'guard-bundler', :group => :development
  add_gem 'guard-cucumber', :group => :development if prefer :integration, 'cucumber'
  add_gem 'guard-rails', :group => :development
  add_gem 'guard-rspec', :group => :development if prefer :unit_test, 'rspec'
  add_gem 'rb-inotify', :group => :development, :require => false
  add_gem 'rb-fsevent', :group => :development, :require => false
  add_gem 'rb-fchange', :group => :development, :require => false
end
add_gem 'factory_girl_rails', :group => [:development, :test] if prefer :fixtures, 'factory_girl'
add_gem 'fabrication', :group => [:development, :test] if prefer :fixtures, 'fabrication'
add_gem 'machinist', :group => :test if prefer :fixtures, 'machinist'

## Front-end Framework
add_gem 'bootstrap-sass' if prefer :bootstrap, 'sass'
add_gem 'compass-rails', :group => :assets if prefer :frontend, 'foundation'
add_gem 'zurb-foundation', :group => :assets if prefer :frontend, 'foundation'
if prefer :bootstrap, 'less'
  add_gem 'less-rails', :group => :assets
  add_gem 'twitter-bootstrap-rails', :group => :assets
  # install gem 'therubyracer' to use Less
  add_gem 'libv8'
  add_gem 'therubyracer', :group => :assets, :platform => :ruby, :require => 'v8'
end

## Email
add_gem 'sendgrid' if prefer :email, 'sendgrid'

## Authentication (Devise)
if Rails::VERSION::MAJOR.to_s == "4"
  add_gem 'devise','>= 3.0.0.rc' if prefer :authentication, 'devise'
else
  add_gem 'devise' if prefer :authentication, 'devise'
end

add_gem 'devise_invitable' if prefer :devise_modules, 'invitable'

## Authentication (OmniAuth)
add_gem 'omniauth' if prefer :authentication, 'omniauth'
add_gem 'omniauth-twitter' if prefer :omniauth_provider, 'twitter'
add_gem 'omniauth-facebook' if prefer :omniauth_provider, 'facebook'
add_gem 'omniauth-github' if prefer :omniauth_provider, 'github'
add_gem 'omniauth-linkedin' if prefer :omniauth_provider, 'linkedin'
add_gem 'omniauth-google-oauth2' if prefer :omniauth_provider, 'google_oauth2'
add_gem 'omniauth-tumblr' if prefer :omniauth_provider, 'tumblr'

## Authorization
if prefer :authorization, 'cancan'
  add_gem 'cancan'
  add_gem 'rolify'
end

## Form Builder
add_gem 'simple_form' if prefer :form_builder, 'simple_form'

## Membership App
if prefer :railsapps, 'rails-stripe-membership-saas'
  add_gem 'stripe'
  add_gem 'stripe_event'
end
if prefer :railsapps, 'rails-recurly-subscription-saas'
  add_gem 'recurly'
  add_gem 'nokogiri'
  add_gem 'countries'
  add_gem 'httpi'
  add_gem 'httpclient'
end

## Signup App
if prefer :railsapps, 'rails-prelaunch-signup'
  add_gem 'gibbon'
  add_gem 'capybara-webkit', :group => :test
end

## Gems from a defaults file or added interactively
gems.each do |g|
  gem(*g)
end

## Git
git :add => '-A' if prefer :git, true
git :commit => '-qm "rails_apps_composer: Gemfile"' if prefer :git, true

### CREATE DATABASE ###
after_bundler do
  copy_from_repo 'config/database-postgresql.yml', :prefs => 'postgresql'
  copy_from_repo 'config/database-mysql.yml', :prefs => 'mysql'
  generate 'mongoid:config' if prefer :orm, 'mongoid'
  remove_file 'config/database.yml' if prefer :orm, 'mongoid'
  if prefer :database, 'postgresql'
    begin
      pg_username = ask_wizard("Username for PostgreSQL? (leave blank to use the app name)")
      if pg_username.blank?
        say_wizard "Creating a user named '#{app_name}' for PostgreSQL"
        run "createuser #{app_name}" if prefer :database, 'postgresql'
        gsub_file "config/database.yml", /username: .*/, "username: #{app_name}"
      else
        gsub_file "config/database.yml", /username: .*/, "username: #{pg_username}"
        pg_password = ask_wizard("Password for PostgreSQL user #{pg_username}?")
        gsub_file "config/database.yml", /password:/, "password: #{pg_password}"
        say_wizard "set config/database.yml for username/password #{pg_username}/#{pg_password}"
      end
    rescue StandardError => e
      raise "unable to create a user for PostgreSQL, reason: #{e}"
    end
    gsub_file "config/database.yml", /database: myapp_development/, "database: #{app_name}_development"
    gsub_file "config/database.yml", /database: myapp_test/,        "database: #{app_name}_test"
    gsub_file "config/database.yml", /database: myapp_production/,  "database: #{app_name}_production"
  end
  if prefer :database, 'mysql'
    mysql_username = ask_wizard("Username for MySQL? (leave blank to use the app name)")
    if mysql_username.blank?
      gsub_file "config/database.yml", /username: .*/, "username: #{app_name}"
    else
      gsub_file "config/database.yml", /username: .*/, "username: #{mysql_username}"
      mysql_password = ask_wizard("Password for MySQL user #{mysql_username}?")
      gsub_file "config/database.yml", /password:/, "password: #{mysql_password}"
      say_wizard "set config/database.yml for username/password #{mysql_username}/#{mysql_password}"
    end
    gsub_file "config/database.yml", /database: myapp_development/, "database: #{app_name}_development"
    gsub_file "config/database.yml", /database: myapp_test/,        "database: #{app_name}_test"
    gsub_file "config/database.yml", /database: myapp_production/,  "database: #{app_name}_production"
  end
  unless prefer :database, 'sqlite'
    affirm = yes_wizard? "Drop any existing databases named #{app_name}?"
    if affirm
      run 'bundle exec rake db:drop'
    else
      raise "aborted at user's request"
    end
  end
  run 'bundle exec rake db:create:all' unless prefer :orm, 'mongoid'
  run 'bundle exec rake db:create' if prefer :orm, 'mongoid'
  ## Git
  git :add => '-A' if prefer :git, true
  git :commit => '-qm "rails_apps_composer: create database"' if prefer :git, true
end # after_bundler

### GENERATORS ###
after_bundler do
  ## Front-end Framework
  generate 'foundation:install' if prefer :frontend, 'foundation'
  ## Form Builder
  if prefer :form_builder, 'simple_form'
    if prefer :frontend, 'bootstrap'
      say_wizard "recipe installing simple_form for use with Twitter Bootstrap"
      generate 'simple_form:install --bootstrap'
    else
      say_wizard "recipe installing simple_form"
      generate 'simple_form:install'
    end
  end
  ## Figaro Gem
  if prefs[:local_env_file]
    generate 'figaro:install'
    gsub_file 'config/application.yml', /# PUSHER_.*\n/, ''
    gsub_file 'config/application.yml', /# STRIPE_.*\n/, ''
    prepend_to_file 'config/application.yml' do <<-FILE
# Add account credentials and API keys here.
# See http://railsapps.github.io/rails-environment-variables.html
# This file should be listed in .gitignore to keep your settings secret!
# Each entry sets a local environment variable and overrides ENV variables in the Unix shell.
# For example, setting:
# GMAIL_USERNAME: Your_Gmail_Username
# makes 'Your_Gmail_Username' available as ENV["GMAIL_USERNAME"]
FILE
    end
  end
  ## Git
  git :add => '-A' if prefer :git, true
  git :commit => '-qm "rails_apps_composer: generators"' if prefer :git, true
end # after_bundler

__END__

name: gems
description: "Add the gems your application needs."
author: RailsApps

requires: [setup]
run_after: [setup]
category: configuration
