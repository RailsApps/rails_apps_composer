# Application template recipe for the rails_apps_composer. Change the recipe here:
# https://github.com/RailsApps/rails_apps_composer/blob/master/recipes/gems.rb

### GEMFILE ###

## Ruby on Rails
insert_into_file 'Gemfile', "ruby '1.9.3'\n", :before => "gem 'rails', '3.2.6'" if prefer :deploy, 'heroku'

## Web Server
gem 'thin', '>= 1.4.1', :group => [:development, :test] if prefer :dev_webserver, 'thin'
gem 'unicorn', '>= 4.3.1', :group => [:development, :test] if prefer :dev_webserver, 'unicorn'
gem 'puma', '>= 1.5.0', :group => [:development, :test] if prefer :dev_webserver, 'puma'
gem 'thin', '>= 1.4.1', :group => :production if prefer :prod_webserver, 'thin'
gem 'unicorn', '>= 4.3.1', :group => :production if prefer :prod_webserver, 'unicorn'
gem 'puma', '>= 1.5.0', :group => :production if prefer :prod_webserver, 'puma'

## Database Adapter
gem 'mongoid', '>= 3.0.1' if prefer :orm, 'mongoid'
gem 'pg', '>= 0.14.0' if prefer :database, 'postgresql'
gem 'mysql2', '>= 0.3.11' if prefer :database, 'mysql'
copy_from_repo 'config/database-postgresql.yml', :prefs => 'postgresql'
copy_from_repo 'config/database-mysql.yml', :prefs => 'mysql'

## Template Engine
if prefer :templates, 'haml'
  gem 'haml', '>= 3.1.6'
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
  gem 'launchy', '>= 2.1.0', :group => :test
end
gem 'turnip', '>= 1.0.0', :group => :test if prefer :integration, 'turnip'
gem 'factory_girl_rails', '>= 3.5.0', :group => [:development, :test] if prefer :fixtures, 'factory_girl'
gem 'machinist', :group => :test if prefer :fixtures, 'machinist'

## Front-end Framework
gem 'bootstrap-sass', '>= 2.0.4.0' if prefer :bootstrap, 'sass'
gem 'zurb-foundation', '>= 3.0.5' if prefer :frontend, 'foundation'
if prefer :bootstrap, 'less'
  gem 'twitter-bootstrap-rails', '>= 2.0.3', :group => :assets
  # install gem 'therubyracer' to use Less
  gem 'therubyracer', :group => :assets, :platform => :ruby
end

## Email
gem 'sendgrid' if prefer :email, 'sendgrid'
gem 'hominid' if prefer :email, 'mandrill'

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
  gem 'rolify', '>= 3.1.0'
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

### GENERATORS ###
after_bundler do
  ## Database
  generate 'mongoid:config' if prefer :orm, 'mongoid'
  remove_file 'config/database.yml' if prefer :orm, 'mongoid'
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
