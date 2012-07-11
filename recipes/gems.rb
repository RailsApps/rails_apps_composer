# Application template recipe for the rails_apps_composer. Check for a newer version here:
# https://github.com/RailsApps/rails_apps_composer/blob/master/recipes/gems.rb

# Ruby on Rails
insert_into_file 'Gemfile', "ruby '1.9.3'\n", :before => "gem 'rails', '3.2.6'" if recipes.include? 'heroku'

# Database
gem 'mongoid', '>= 2.4.11' if recipes.include? 'mongoid'

# Template Engine
if recipes.include? 'haml'
  gem 'haml', '>= 3.1.6'
  gem 'haml-rails', '>= 0.3.4', :group => :development
end

# Testing Framework
if recipes.include? 'rspec'
  gem 'rspec-rails', '>= 2.10.1', :group => [:development, :test]
  gem 'capybara', '>= 1.1.2', :group => :test
  if recipes.include? 'mongoid'
    # use the database_cleaner gem to reset the test database
    gem 'database_cleaner', '>= 0.8.0', :group => :test
    # include RSpec matchers from the mongoid-rspec gem
    gem 'mongoid-rspec', '1.4.5', :group => :test
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

# Front-end Framework
gem 'bootstrap-sass', '>= 2.0.4.0' if recipes.include? 'bootstrap_sass'
gem 'zurb-foundation', '>= 3.0.3' if recipes.include? 'foundation'
if recipes.include? 'bootstrap_less'
  gem 'twitter-bootstrap-rails', '>= 2.0.3', :group => :assets
  gem 'therubyracer', :group => :assets, :platform => :ruby # install gem 'therubyracer' to use Less
end

# Form Builder
gem 'simple_form' if recipes.include? 'simple_form'

# Email
gem 'sendgrid' if recipes.include? 'sendgrid'
gem 'hominid' if recipes.include? 'mandrill'

# Authentication (Devise)
gem 'devise', '>= 2.1.2' if recipes.include? 'devise'
gem 'devise_invitable', '>= 1.0.2' if recipes.include? 'devise-invitable'

# Authentication (OmniAuth)
gem 'omniauth', '>= 1.1.0' if recipes.include? 'omniauth'
gem 'omniauth-twitter' if recipes.include? 'twitter'
gem 'omniauth-facebook' if recipes.include? 'facebook'
gem 'omniauth-github' if recipes.include? 'github'
gem 'omniauth-linkedin' if recipes.include? 'linkedin'
gem 'omniauth-google-oauth2' if recipes.include? 'google-oauth2'
gem 'omniauth-tumblr' if recipes.include? 'tumblr'

# Authorization 
if recipes.include? 'cancan'
  gem 'cancan', '>= 1.6.8'
  gem 'rolify', '>= 3.1.0'
end
