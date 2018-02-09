# Application template recipe for the rails_apps_composer. Change the recipe here:
# https://github.com/RailsApps/rails_apps_composer/blob/master/recipes/gems.rb

### GEMFILE ###

## Ruby on Rails
insert_into_file('Gemfile', "ruby '#{RUBY_VERSION}'\n", :before => /^ *gem 'rails'/, :force => false)

## Cleanup
# remove the 'sdoc' gem
if Rails::VERSION::MAJOR == 4 && Rails::VERSION::MINOR >= 2
  gsub_file 'Gemfile', /gem 'sdoc',\s+'~> 0.4.0',\s+group: :doc/, ''
else
  gsub_file 'Gemfile', /group :doc do/, ''
  gsub_file 'Gemfile', /\s*gem 'sdoc', require: false\nend/, ''
end

## Web Server
if (prefs[:dev_webserver] == prefs[:prod_webserver])
  add_gem 'thin' if prefer :dev_webserver, 'thin'
  add_gem 'unicorn' if prefer :dev_webserver, 'unicorn'
  add_gem 'unicorn-rails' if prefer :dev_webserver, 'unicorn'
  add_gem 'passenger' if prefer :dev_webserver, 'passenger_standalone'
else
  add_gem 'thin', :group => [:development, :test] if prefer :dev_webserver, 'thin'
  add_gem 'unicorn', :group => [:development, :test] if prefer :dev_webserver, 'unicorn'
  add_gem 'unicorn-rails', :group => [:development, :test] if prefer :dev_webserver, 'unicorn'
  add_gem 'passenger', :group => [:development, :test] if prefer :dev_webserver, 'passenger_standalone'
  add_gem 'thin', :group => :production if prefer :prod_webserver, 'thin'
  add_gem 'unicorn', :group => :production if prefer :prod_webserver, 'unicorn'
  add_gem 'passenger', :group => :production if prefer :prod_webserver, 'passenger_standalone'
end

## Database Adapter
gsub_file 'Gemfile', /gem 'sqlite3'\n/, '' unless prefer :database, 'sqlite'
gsub_file 'Gemfile', /gem 'pg'.*/, ''
if prefer :database, 'postgresql'
  if Rails::VERSION::MAJOR < 5
    add_gem 'pg', '~> 0.18'
  else
    if Rails::VERSION::MAJOR == 5 && Rails::VERSION::MINOR <= 1 && Rails::VERSION::MINOR <= 5
      add_gem 'pg', '~> 0.18'
    else
      add_gem 'pg'
    end
  end
end
gsub_file 'Gemfile', /gem 'mysql2'.*/, ''
add_gem 'mysql2', '~> 0.3.18' if prefer :database, 'mysql'
## Gem to set up controllers, views, and routing in the 'apps4' recipe
add_gem 'rails_apps_pages', :group => :development if prefs[:apps4]

## Template Engine
if prefer :templates, 'haml'
  add_gem 'haml-rails'
  add_gem 'html2haml', :group => :development
end
if prefer :templates, 'slim'
  add_gem 'slim-rails'
  add_gem 'haml2slim', :group => :development
  add_gem 'html2haml', :group => :development
end

## Testing Framework
if prefer :tests, 'rspec'
  add_gem 'rails_apps_testing', :group => :development
  add_gem 'rspec-rails', :group => [:development, :test]
  add_gem 'spring-commands-rspec', :group => :development
  add_gem 'factory_bot_rails', :group => [:development, :test]
  add_gem 'faker', :group => [:development, :test]
  unless Rails::VERSION::MAJOR == 5 && Rails::VERSION::MINOR >= 1
    add_gem 'capybara', :group => :test
    add_gem 'selenium-webdriver', :group => :test
  end
  add_gem 'database_cleaner', :group => :test
  add_gem 'launchy', :group => :test
  if prefer :continuous_testing, 'guard'
    add_gem 'guard-bundler', :group => :development
    add_gem 'guard-rails', :group => :development
    add_gem 'guard-rspec', :group => :development
    add_gem 'rb-inotify', :group => :development, :require => false
    add_gem 'rb-fsevent', :group => :development, :require => false
    add_gem 'rb-fchange', :group => :development, :require => false
  end
end

## Front-end Framework
add_gem 'rails_layout', :group => :development
case prefs[:frontend]
  when 'bootstrap2'
    add_gem 'bootstrap-sass', '~> 2.3.2.2'
  when 'bootstrap3'
    add_gem 'bootstrap-sass'
  when 'bootstrap4'
    add_gem 'bootstrap', '~> 4.0.0'
  when 'foundation4'
    add_gem 'zurb-foundation', '~> 4.3.2'
    add_gem 'compass-rails', '~> 1.1.2'
  when 'foundation5'
    add_gem 'foundation-rails', '~> 5.5'
end

## jQuery
case prefs[:jquery]
  when 'gem'
    add_gem 'jquery-rails'
  when 'yarn'
    run 'bundle exec yarn add jquery'
end

## Pages
case prefs[:pages]
  when 'about'
    add_gem 'high_voltage'
  when 'about+users'
    add_gem 'high_voltage'
end

## Authentication (Devise)
if prefer :authentication, 'devise'
    add_gem 'devise'
    add_gem 'devise_invitable' if prefer :devise_modules, 'invitable'
end

## Administratative Interface
if prefer :dashboard, 'administrate'
  add_gem 'administrate'
  add_gem 'bourbon'
end

## Authentication (OmniAuth)
add_gem 'omniauth' if prefer :authentication, 'omniauth'
add_gem 'omniauth-twitter' if prefer :omniauth_provider, 'twitter'
add_gem 'omniauth-facebook' if prefer :omniauth_provider, 'facebook'
add_gem 'omniauth-github' if prefer :omniauth_provider, 'github'
add_gem 'omniauth-linkedin' if prefer :omniauth_provider, 'linkedin'
add_gem 'omniauth-google-oauth2' if prefer :omniauth_provider, 'google_oauth2'
add_gem 'omniauth-tumblr' if prefer :omniauth_provider, 'tumblr'

## Authorization
add_gem 'pundit' if prefer :authorization, 'pundit'

## Form Builder
add_gem 'simple_form' if prefer :form_builder, 'simple_form'

## Gems from a defaults file or added interactively
gems.each do |g|
  add_gem(*g)
end

## Git
git :add => '-A' if prefer :git, true
git :commit => '-qm "rails_apps_composer: Gemfile"' if prefer :git, true

### CREATE DATABASE ###
stage_two do
  say_wizard "recipe stage two"
  say_wizard "configuring database"
  unless prefer :database, 'sqlite'
    copy_from_repo 'config/database-postgresql.yml', :prefs => 'postgresql'
    copy_from_repo 'config/database-mysql.yml', :prefs => 'mysql'
    if prefer :database, 'postgresql'
      begin
        pg_username = prefs[:pg_username] || ask_wizard("Username for PostgreSQL?(leave blank to use the app name)")
        pg_host = prefs[:pg_host] || ask_wizard("Host for PostgreSQL in database.yml? (leave blank to use default socket connection)")
        if pg_username.blank?
          say_wizard "Creating a user named '#{app_name}' for PostgreSQL"
          run "createuser --createdb #{app_name}" if prefer :database, 'postgresql'
          gsub_file "config/database.yml", /username: .*/, "username: #{app_name}"
        else
          gsub_file "config/database.yml", /username: .*/, "username: #{pg_username}"
          pg_password = prefs[:pg_password] || ask_wizard("Password for PostgreSQL user #{pg_username}?")
          gsub_file "config/database.yml", /password:/, "password: #{pg_password}"
          say_wizard "set config/database.yml for username/password #{pg_username}/#{pg_password}"
        end
        if pg_host.present?
          gsub_file "config/database.yml", /  host:     localhost/, "  host:     #{pg_host}"
        end
      rescue StandardError => e
        raise "unable to create a user for PostgreSQL, reason: #{e}"
      end
      gsub_file "config/database.yml", /database: myapp_development/, "database: #{app_name}_development"
      gsub_file "config/database.yml", /database: myapp_test/,        "database: #{app_name}_test"
      gsub_file "config/database.yml", /database: myapp_production/,  "database: #{app_name}_production"
    end
    if prefer :database, 'mysql'
      mysql_username = prefs[:mysql_username] || ask_wizard("Username for MySQL? (leave blank to use the app name)")
      if mysql_username.blank?
        gsub_file "config/database.yml", /username: .*/, "username: #{app_name}"
      else
        gsub_file "config/database.yml", /username: .*/, "username: #{mysql_username}"
        mysql_password = prefs[:mysql_password] || ask_wizard("Password for MySQL user #{mysql_username}?")
        gsub_file "config/database.yml", /password:/, "password: #{mysql_password}"
        say_wizard "set config/database.yml for username/password #{mysql_username}/#{mysql_password}"
      end
      gsub_file "config/database.yml", /database: myapp_development/, "database: #{app_name}_development"
      gsub_file "config/database.yml", /database: myapp_test/,        "database: #{app_name}_test"
      gsub_file "config/database.yml", /database: myapp_production/,  "database: #{app_name}_production"
    end
    unless prefer :database, 'sqlite'
      if (prefs.has_key? :drop_database) ? prefs[:drop_database] :
          (yes_wizard? "Okay to drop all existing databases named #{app_name}? 'No' will abort immediately!")
        run 'bundle exec rake db:drop'
      else
        raise "aborted at user's request"
      end
    end
    run 'bundle exec rake db:create:all'
    ## Git
    git :add => '-A' if prefer :git, true
    git :commit => '-qm "rails_apps_composer: create database"' if prefer :git, true
  end
end

### GENERATORS ###
stage_two do
  say_wizard "recipe stage two"
  say_wizard "running generators"
  ## Form Builder
  if prefer :form_builder, 'simple_form'
    case prefs[:frontend]
      when 'bootstrap2'
        say_wizard "recipe installing simple_form for use with Bootstrap"
        generate 'simple_form:install --bootstrap'
      when 'bootstrap3'
        say_wizard "recipe installing simple_form for use with Bootstrap"
        generate 'simple_form:install --bootstrap'
      when 'bootstrap4'
        say_wizard "simple_form not yet available for use with Bootstrap 4"
      when 'foundation5'
        say_wizard "recipe installing simple_form for use with Zurb Foundation"
        generate 'simple_form:install --foundation'
      when 'foundation4'
        say_wizard "recipe installing simple_form for use with Zurb Foundation"
        generate 'simple_form:install --foundation'
      else
        say_wizard "recipe installing simple_form"
        generate 'simple_form:install'
    end
  end
  ## Figaro Gem
  if prefer :local_env_file, 'figaro'
    run 'figaro install'
    gsub_file 'config/application.yml', /# PUSHER_.*\n/, ''
    gsub_file 'config/application.yml', /# STRIPE_.*\n/, ''
    prepend_to_file 'config/application.yml' do <<-FILE
# Add account credentials and API keys here.
# See http://railsapps.github.io/rails-environment-variables.html
# This file should be listed in .gitignore to keep your settings secret!
# Each entry sets a local environment variable.
# For example, setting:
# GMAIL_USERNAME: Your_Gmail_Username
# makes 'Your_Gmail_Username' available as ENV["GMAIL_USERNAME"]

FILE
    end
  end
  ## Foreman Gem
  if prefer :local_env_file, 'foreman'
    create_file '.env' do <<-FILE
# Add account credentials and API keys here.
# This file should be listed in .gitignore to keep your settings secret!
# Each entry sets a local environment variable.
# For example, setting:
# GMAIL_USERNAME=Your_Gmail_Username
# makes 'Your_Gmail_Username' available as ENV["GMAIL_USERNAME"]

FILE
    end
    create_file 'Procfile', "web: bundle exec rails server -p $PORT\n" if prefer :prod_webserver, 'thin'
    create_file 'Procfile', "web: bundle exec unicorn -p $PORT\n" if prefer :prod_webserver, 'unicorn'
    create_file 'Procfile', "web: bundle exec passenger start -p $PORT\n" if prefer :prod_webserver, 'passenger_standalone'
    if (prefs[:dev_webserver] != prefs[:prod_webserver])
      create_file 'Procfile.dev', "web: bundle exec rails server -p $PORT\n" if prefer :dev_webserver, 'thin'
      create_file 'Procfile.dev', "web: bundle exec unicorn -p $PORT\n" if prefer :dev_webserver, 'unicorn'
      create_file 'Procfile.dev', "web: bundle exec passenger start -p $PORT\n" if prefer :dev_webserver, 'passenger_standalone'
    end
  end
  ## Git
  git :add => '-A' if prefer :git, true
  git :commit => '-qm "rails_apps_composer: generators"' if prefer :git, true
end

__END__

name: gems
description: "Add the gems your application needs."
author: RailsApps

requires: [setup]
run_after: [setup]
category: configuration
