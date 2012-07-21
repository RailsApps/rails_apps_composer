# Application template recipe for the rails_apps_composer. Change the recipe here:
# https://github.com/RailsApps/rails_apps_composer/blob/master/recipes/gems.rb

### GEMFILE ###

## Ruby on Rails
insert_into_file 'Gemfile', "ruby '1.9.3'\n", :before => "gem 'rails', '3.2.6'" if recipes.include? 'heroku'

## Web Server
gem 'thin', '>= 1.4.1', :group => [:development, :test] if recipes.include? 'thin-development'
gem 'unicorn', '>= 4.3.1', :group => [:development, :test] if recipes.include? 'unicorn-development'
gem 'thin', '>= 1.4.1', :group => :production if recipes.include? 'thin-production'
gem 'unicorn', '>= 4.3.1', :group => :production if recipes.include? 'unicorn-production'

## Database Adapter
gem 'mongoid', '>= 3.0.1' if recipes.include? 'mongoid'
gem 'pg', '>= 0.14.0' if recipes.include? 'postgresql'
gem 'mysql2', '>= 0.3.11' if recipes.include? 'mysql'
repo = 'https://raw.github.com/RailsApps/rails3-application-templates/master/files-v2/'
copy_from_repo 'database.yml', repo, :recipe => 'postgresql'
copy_from_repo 'database.yml', repo, :recipe => 'mysql'

## Template Engine
if recipes.include? 'haml'
  gem 'haml', '>= 3.1.6'
  gem 'haml-rails', '>= 0.3.4', :group => :development
end

## Testing Framework
if recipes.include? 'rspec'
  gem 'rspec-rails', '>= 2.11.0', :group => [:development, :test]
  gem 'capybara', '>= 1.1.2', :group => :test
  if recipes.include? 'mongoid'
    # use the database_cleaner gem to reset the test database
    gem 'database_cleaner', '>= 0.8.0', :group => :test
    # include RSpec matchers from the mongoid-rspec gem
    gem 'mongoid-rspec', '>= 1.4.6', :group => :test
  end
  # fixture replacements
  gem 'machinist', :group => :test if recipes.include? 'machinist'
  gem 'factory_girl_rails', '>= 3.5.0', :group => [:development, :test] if recipes.include? 'factory_girl'
  # Cucumber for BDD
  if recipes.include? 'cucumber'
    gem 'cucumber-rails', '>= 1.3.0', :group => :test, :require => false
    gem 'database_cleaner', '>= 0.8.0', :group => :test unless recipes.include? 'mongoid'
    gem 'launchy', '>= 2.1.0', :group => :test
  end
  # add a collection of RSpec matchers and Cucumber steps to make testing email easy
  gem 'email_spec', '>= 1.2.1', :group => :test if recipes.include? 'email'
end  

## Front-end Framework
gem 'bootstrap-sass', '>= 2.0.4.0' if recipes.include? 'bootstrap_sass'
gem 'zurb-foundation', '>= 3.0.5' if recipes.include? 'foundation'
if recipes.include? 'bootstrap_less'
  gem 'twitter-bootstrap-rails', '>= 2.0.3', :group => :assets
  # install gem 'therubyracer' to use Less
  gem 'therubyracer', :group => :assets, :platform => :ruby
end

## Form Builder
gem 'simple_form' if recipes.include? 'simple_form'

## Email
gem 'sendgrid' if recipes.include? 'sendgrid'
gem 'hominid' if recipes.include? 'mandrill'

## Authentication (Devise)
gem 'devise', '>= 2.1.2' if recipes.include? 'devise'
gem 'devise_invitable', '>= 1.0.3' if recipes.include? 'devise-invitable'

## Authentication (OmniAuth)
gem 'omniauth', '>= 1.1.0' if recipes.include? 'omniauth'
gem 'omniauth-twitter' if recipes.include? 'twitter'
gem 'omniauth-facebook' if recipes.include? 'facebook'
gem 'omniauth-github' if recipes.include? 'github'
gem 'omniauth-linkedin' if recipes.include? 'linkedin'
gem 'omniauth-google-oauth2' if recipes.include? 'google-oauth2'
gem 'omniauth-tumblr' if recipes.include? 'tumblr'

## Authorization 
if recipes.include? 'cancan'
  gem 'cancan', '>= 1.6.8'
  gem 'rolify', '>= 3.1.0'
end

## Git
git :add => '.' if recipes.include? 'git'
git :commit => "-aqm 'rails_apps_composer: Gemfile'" if recipes.include? 'git'

### GENERATORS ###
after_bundler do
  ## Database
  generate 'mongoid:config' if recipes.include? 'mongoid'
  remove_file 'config/database.yml' if recipes.include? 'mongoid'
  ## Form Builder
  if recipes.include? 'simple_form'
    if recipes.include? 'bootstrap'
      say_wizard "recipe installing simple_form for use with Twitter Bootstrap"
      generate 'simple_form:install --bootstrap'
    else
      say_wizard "recipe installing simple_form"
      generate 'simple_form:install'
    end
  end
  ## Git
  git :add => '.' if recipes.include? 'git'
  git :commit => "-aqm 'rails_apps_composer: generators'" if recipes.include? 'git'
end # after_bundler

__END__

name: gems
description: "Add the gems your application needs."
author: RailsApps

category: other
tags: [utilities, configuration]
