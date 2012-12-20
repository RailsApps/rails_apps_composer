# Application template recipe for the rails_apps_composer. Change the recipe here:
# https://github.com/RailsApps/rails_apps_composer/blob/master/recipes/gems.rb

### GEMFILE ###

## Ruby on Rails
insert_into_file 'Gemfile', "ruby '1.9.3'\n", :before => "gem 'rails', '3.2.6'" if prefer :deploy, 'heroku'

## Web Server
if (prefs[:dev_webserver] == prefs[:prod_webserver])
  gem 'thin', '>= 1.5.0' if prefer :dev_webserver, 'thin'
  gem 'unicorn', '>= 4.3.1' if prefer :dev_webserver, 'unicorn'
  gem 'puma', '>= 1.6.3' if prefer :dev_webserver, 'puma'
else
  gem 'thin', '>= 1.5.0', :group => [:development, :test] if prefer :dev_webserver, 'thin'
  gem 'unicorn', '>= 4.3.1', :group => [:development, :test] if prefer :dev_webserver, 'unicorn'
  gem 'puma', '>= 1.6.3', :group => [:development, :test] if prefer :dev_webserver, 'puma'
  gem 'thin', '>= 1.5.0', :group => :production if prefer :prod_webserver, 'thin'
  gem 'unicorn', '>= 4.3.1', :group => :production if prefer :prod_webserver, 'unicorn'
  gem 'puma', '>= 1.6.3', :group => :production if prefer :prod_webserver, 'puma'
end

## Database Adapter
gsub_file 'Gemfile', /gem 'sqlite3'\n/, '' unless prefer :database, 'sqlite'
gem 'mongoid', '>= 3.0.9' if prefer :orm, 'mongoid'
gem 'pg', '>= 0.14.1' if prefer :database, 'postgresql'
gem 'mysql2', '>= 0.3.11' if prefer :database, 'mysql'

## Template Engine
if prefer :templates, 'haml'
  gem 'haml', '>= 3.1.7'
  gem 'haml-rails', '>= 0.3.5', :group => :development
  # hpricot and ruby_parser are needed for conversion of HTML to Haml
  gem 'hpricot', '>= 0.8.6', :group => :development
  gem 'ruby_parser', '>= 2.3.1', :group => :development
end
if prefer :templates, 'slim'
  gem 'slim', '>= 1.3.2'
  gem 'haml2slim', '>= 0.4.6', :group => :development
  # Haml is needed for conversion of HTML to Slim
  gem 'haml', '>= 3.1.6', :group => :development
  gem 'haml-rails', '>= 0.3.5', :group => :development
  gem 'hpricot', '>= 0.8.6', :group => :development
  gem 'ruby_parser', '>= 2.3.1', :group => :development
end

## Testing Framework
if prefer :unit_test, 'rspec'
  gem 'rspec-rails', '>= 2.11.0', :group => [:development, :test]
  gem 'capybara', '>= 1.1.2', :group => :test if prefer :integration, 'rspec-capybara'
  if prefer :orm, 'mongoid'
    # use the database_cleaner gem to reset the test database
    gem 'database_cleaner', '>= 0.9.1', :group => :test
    # include RSpec matchers from the mongoid-rspec gem
    gem 'mongoid-rspec', '>= 1.4.6', :group => :test
  end
  gem 'email_spec', '>= 1.2.1', :group => :test
end
if prefer :unit_test, 'minitest'
  gem 'minitest-spec-rails', '>= 3.0.7', :group => :test
  gem 'minitest-wscolor', '>= 0.0.3', :group => :test
  gem 'capybara', '>= 1.1.2', :group => :test if prefer :integration, 'minitest-capybara'
end
if prefer :integration, 'cucumber'
  gem 'cucumber-rails', '>= 1.3.0', :group => :test, :require => false
  gem 'database_cleaner', '>= 0.9.1', :group => :test unless prefer :orm, 'mongoid'
  gem 'launchy', '>= 2.1.2', :group => :test
  gem 'capybara', '>= 1.1.2', :group => :test
end
gem 'turnip', '>= 1.0.0', :group => :test if prefer :integration, 'turnip'
gem 'factory_girl_rails', '>= 4.1.0', :group => [:development, :test] if prefer :fixtures, 'factory_girl'
gem 'fabrication', '>= 2.3.0', :group => [:development, :test] if prefer :fixtures, 'fabrication'
gem 'machinist', '>= 2.0', :group => :test if prefer :fixtures, 'machinist'

## Front-end Framework
gem 'bootstrap-sass', '>= 2.1.0.0' if prefer :bootstrap, 'sass'
gem 'compass-rails', '>= 1.0.3', :group => :assets if prefer :frontend, 'foundation'
gem 'zurb-foundation', '>= 3.1.1', :group => :assets if prefer :frontend, 'foundation'
if prefer :bootstrap, 'less'
  gem 'twitter-bootstrap-rails', '>= 2.1.3', :group => :assets
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
gem 'omniauth', '>= 1.1.1' if prefer :authentication, 'omniauth'
gem 'omniauth-twitter' if prefer :omniauth_provider, 'twitter'
gem 'omniauth-facebook' if prefer :omniauth_provider, 'facebook'
gem 'omniauth-github' if prefer :omniauth_provider, 'github'
gem 'omniauth-linkedin' if prefer :omniauth_provider, 'linkedin'
gem 'omniauth-google-oauth2' if prefer :omniauth_provider, 'google_oauth2'
gem 'omniauth-tumblr' if prefer :omniauth_provider, 'tumblr'

## Authorization 
if prefer :authorization, 'cancan'
  gem 'cancan', '>= 1.6.8'
  gem 'rolify', '>= 3.2.0'
end

## Form Builder
gem 'simple_form', '>= 2.0.4' if prefer :form_builder, 'simple_form'

## Signup App 
if prefer :railsapps, 'rails-prelaunch-signup'
  gem 'google_visualr', '>= 2.1.2'
  gem 'jquery-datatables-rails', '>= 1.11.1'
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
