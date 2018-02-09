# Application template recipe for the rails_apps_composer. Change the recipe here:
# https://github.com/RailsApps/rails_apps_composer/blob/master/recipes/setup.rb

## Ruby on Rails
HOST_OS = RbConfig::CONFIG['host_os']
say_wizard "Your operating system is #{HOST_OS}."
say_wizard "You are using Ruby version #{RUBY_VERSION}."
say_wizard "You are using Rails version #{Rails::VERSION::STRING}."

## Is sqlite3 in the Gemfile?
gemfile = File.read(destination_root() + '/Gemfile')
sqlite_detected = gemfile.include? 'sqlite3'

## Web Server
prefs[:dev_webserver] = multiple_choice "Web server for development?", [["Puma (default)", "puma"],
  ["Thin", "thin"], ["Unicorn", "unicorn"], ["Phusion Passenger (Apache/Nginx)", "passenger"],
  ["Phusion Passenger (Standalone)", "passenger_standalone"]] unless prefs.has_key? :dev_webserver
prefs[:prod_webserver] = multiple_choice "Web server for production?", [["Same as development", "same"],
  ["Thin", "thin"], ["Unicorn", "unicorn"], ["Phusion Passenger (Apache/Nginx)", "passenger"],
  ["Phusion Passenger (Standalone)", "passenger_standalone"]] unless prefs.has_key? :prod_webserver
prefs[:prod_webserver] = prefs[:dev_webserver] if prefs[:prod_webserver] == 'same'

## Database Adapter
prefs[:database] = "sqlite" if prefer :database, 'default'
prefs[:database] = multiple_choice "Database used in development?", [["SQLite", "sqlite"], ["PostgreSQL", "postgresql"],
  ["MySQL", "mysql"]] unless prefs.has_key? :database

## Template Engine
prefs[:templates] = multiple_choice "Template engine?", [["ERB", "erb"], ["Haml", "haml"], ["Slim", "slim"]] unless prefs.has_key? :templates

## Testing Framework
if recipes.include? 'tests'
  prefs[:tests] = multiple_choice "Test framework?", [["None", "none"],
    ["RSpec", "rspec"]] unless prefs.has_key? :tests
  case prefs[:tests]
    when 'rspec'
      say_wizard "Adding DatabaseCleaner, FactoryGirl, Faker, Launchy, Selenium"
      prefs[:continuous_testing] = multiple_choice "Continuous testing?", [["None", "none"], ["Guard", "guard"]] unless prefs.has_key? :continuous_testing
    end
end

## Front-end Framework
if recipes.include? 'frontend'
  prefs[:frontend] = multiple_choice "Front-end framework?", [["None", "none"],
    ["Bootstrap 4.0", "bootstrap4"], ["Bootstrap 3.3", "bootstrap3"], ["Bootstrap 2.3", "bootstrap2"],
    ["Zurb Foundation 5.5", "foundation5"], ["Zurb Foundation 4.0", "foundation4"],
    ["Simple CSS", "simple"]] unless prefs.has_key? :frontend
end

## jQuery
if Rails::VERSION::MAJOR == 5 && Rails::VERSION::MINOR >= 1
  if prefs[:frontend] == 'none'
    prefs[:jquery] = multiple_choice "Add jQuery?", [["No", "none"],
      ["Add jquery-rails gem", "gem"],
      ["Add using yarn", "yarn"]] unless prefs.has_key? :jquery
  else
    prefs[:jquery] = multiple_choice "How to install jQuery?",
      [["Add jquery-rails gem", "gem"],
      ["Add using yarn", "yarn"]] unless prefs.has_key? :jquery
  end
end

## Email
if recipes.include? 'email'
  unless prefs.has_key? :email
    say_wizard "The Devise 'forgot password' feature requires email." if prefer :authentication, 'devise'
    prefs[:email] = multiple_choice "Add support for sending email?", [["None", "none"], ["Gmail","gmail"], ["SMTP","smtp"],
      ["SendGrid","sendgrid"], ["Mandrill","mandrill"]]
  end
else
  prefs[:email] = 'none'
end

## Authentication and Authorization
if (recipes.include? 'devise') || (recipes.include? 'omniauth')
  prefs[:authentication] = multiple_choice "Authentication?", [["None", "none"], ["Devise", "devise"], ["OmniAuth", "omniauth"]] unless prefs.has_key? :authentication
  case prefs[:authentication]
    when 'devise'
      prefs[:devise_modules] = multiple_choice "Devise modules?", [["Devise with default modules","default"],
      ["Devise with Confirmable module","confirmable"],
      ["Devise with Confirmable and Invitable modules","invitable"]] unless prefs.has_key? :devise_modules
    when 'omniauth'
      prefs[:omniauth_provider] = multiple_choice "OmniAuth provider?", [["Facebook", "facebook"], ["Twitter", "twitter"], ["GitHub", "github"],
        ["LinkedIn", "linkedin"], ["Google-Oauth-2", "google_oauth2"], ["Tumblr", "tumblr"]] unless prefs.has_key? :omniauth_provider
  end
  prefs[:authorization] = multiple_choice "Authorization?", [["None", "none"], ["Simple role-based", "roles"], ["Pundit", "pundit"]] unless prefs.has_key? :authorization
  if prefer :authentication, 'devise'
    if (prefer :authorization, 'roles') || (prefer :authorization, 'pundit')
      prefs[:dashboard] = multiple_choice "Admin interface for database?", [["None", "none"],
        ["Thoughtbot Administrate", "administrate"]] unless prefs.has_key? :dashboard
    end
  end
end

## Form Builder
## (no simple_form for Bootstrap 4 yet)
unless prefs[:frontend] == 'bootstrap4'
  prefs[:form_builder] = multiple_choice "Use a form builder gem?", [["None", "none"], ["SimpleForm", "simple_form"]] unless prefs.has_key? :form_builder
end

## Pages
if recipes.include? 'pages'
  prefs[:pages] = multiple_choice "Add pages?", [["None", "none"],
    ["Home", "home"], ["Home and About", "about"],
    ["Home and Users", "users"],
    ["Home, About, and Users", "about+users"]] unless prefs.has_key? :pages
end

## Bootstrap Page Templates
if recipes.include? 'pages'
  if prefs[:frontend] == 'bootstrap3'
    say_wizard "Which Bootstrap page template? Visit startbootstrap.com."
    prefs[:layouts] = multiple_choice "Add Bootstrap page templates?", [["None", "none"],
    ["1 Col Portfolio", "one_col_portfolio"],
    ["2 Col Portfolio", "two_col_portfolio"],
    ["3 Col Portfolio", "three_col_portfolio"],
    ["4 Col Portfolio", "four_col_portfolio"],
    ["Bare", "bare"],
    ["Blog Home", "blog_home"],
    ["Business Casual", "business_casual"],
    ["Business Frontpage", "business_frontpage"],
    ["Clean Blog", "clean_blog"],
    ["Full Width Pics", "full_width_pics"],
    ["Heroic Features", "heroic_features"],
    ["Landing Page", "landing_page"],
    ["Modern Business", "modern_business"],
    ["One Page Wonder", "one_page_wonder"],
    ["Portfolio Item", "portfolio_item"],
    ["Round About", "round_about"],
    ["Shop Homepage", "shop_homepage"],
    ["Shop Item", "shop_item"],
    ["Simple Sidebar", "simple_sidebar"],
    ["Small Business", "small_business"],
    ["Stylish Portfolio", "stylish_portfolio"],
    ["The Big Picture", "the_big_picture"],
    ["Thumbnail Gallery", "thumbnail_gallery"]] unless prefs.has_key? :layouts
  end
end

# save configuration before anything can fail
create_file 'config/railscomposer.yml', "# This application was generated with Rails Composer\n\n"
append_to_file 'config/railscomposer.yml' do <<-TEXT
development:
  apps4: #{prefs[:apps4]}
  announcements: #{prefs[:announcements]}
  dev_webserver: #{prefs[:dev_webserver]}
  prod_webserver: #{prefs[:prod_webserver]}
  database: #{prefs[:database]}
  templates: #{prefs[:templates]}
  tests: #{prefs[:tests]}
  continuous_testing: #{prefs[:continuous_testing]}
  frontend: #{prefs[:frontend]}
  email: #{prefs[:email]}
  authentication: #{prefs[:authentication]}
  devise_modules: #{prefs[:devise_modules]}
  omniauth_provider: #{prefs[:omniauth_provider]}
  authorization: #{prefs[:authorization]}
  form_builder: #{prefs[:form_builder]}
  pages: #{prefs[:pages]}
  layouts: #{prefs[:layouts]}
  locale: #{prefs[:locale]}
  analytics: #{prefs[:analytics]}
  deployment: #{prefs[:deployment]}
  ban_spiders: #{prefs[:ban_spiders]}
  github: #{prefs[:github]}
  local_env_file: #{prefs[:local_env_file]}
  better_errors: #{prefs[:better_errors]}
  pry: #{prefs[:pry]}
  rvmrc: #{prefs[:rvmrc]}
  dashboard: #{prefs[:dashboard]}
TEXT
end

__END__

name: setup
description: "Make choices for your application."
author: RailsApps

run_after: [git, railsapps]
category: configuration
