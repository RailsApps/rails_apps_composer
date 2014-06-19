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
prefs[:dev_webserver] = multiple_choice "Web server for development?", [["WEBrick (default)", "webrick"],
  ["Thin", "thin"], ["Unicorn", "unicorn"], ["Puma", "puma"], ["Phusion Passenger (Apache/Nginx)", "passenger"],
  ["Phusion Passenger (Standalone)", "passenger_standalone"]] unless prefs.has_key? :dev_webserver
prefs[:prod_webserver] = multiple_choice "Web server for production?", [["Same as development", "same"],
  ["Thin", "thin"], ["Unicorn", "unicorn"], ["Puma", "puma"], ["Phusion Passenger (Apache/Nginx)", "passenger"],
  ["Phusion Passenger (Standalone)", "passenger_standalone"]] unless prefs.has_key? :prod_webserver
if prefs[:prod_webserver] == 'same'
  case prefs[:dev_webserver]
    when 'thin'
      prefs[:prod_webserver] = 'thin'
    when 'unicorn'
      prefs[:prod_webserver] = 'unicorn'
    when 'puma'
      prefs[:prod_webserver] = 'puma'
    when 'passenger'
      prefs[:prod_webserver] = 'passenger'
    when 'passenger_standalone'
      prefs[:prod_webserver] = 'passenger_standalone'
  end
end

## Database Adapter
if rails_4_1?
  prefs[:database] = multiple_choice "Database used in development?", [["SQLite", "sqlite"], ["PostgreSQL", "postgresql"],
    ["MySQL", "mysql"]] unless prefs.has_key? :database
else
  prefs[:database] = multiple_choice "Database used in development?", [["SQLite", "sqlite"], ["PostgreSQL", "postgresql"],
    ["MySQL", "mysql"], ["MongoDB", "mongodb"]] unless prefs.has_key? :database
end
case prefs[:database]
  when 'mongodb'
    unless sqlite_detected
      prefs[:orm] = multiple_choice "How will you connect to MongoDB?", [["Mongoid","mongoid"]] unless prefs.has_key? :orm
    else
      say_wizard "WARNING! SQLite gem detected in the Gemfile"
      say_wizard "If you wish to use MongoDB you must skip Active Record."
      say_wizard "If using rails_apps_composer, choose 'skip Active Record'."
      say_wizard "If using Rails Composer or an application template, use the '-O' flag as in 'rails new foo -O'."
      prefs[:fail] = multiple_choice "Abort or continue?", [["abort", "abort"], ["continue", "continue"]]
      if prefer :fail, 'abort'
        raise StandardError.new "SQLite detected in the Gemfile. Use '-O' or '--skip-activerecord' as in 'rails new foo -O' if you don't want ActiveRecord and SQLite"
      end
    end
end

## Template Engine
prefs[:templates] = multiple_choice "Template engine?", [["ERB", "erb"], ["Haml", "haml"], ["Slim", "slim"]] unless prefs.has_key? :templates

## Testing Framework
if rails_4_1?
  if recipes.include? 'tests4'
    prefs[:tests] = multiple_choice "Test framework?", [["None", "none"],
      ["RSpec with Capybara", "rspec"]] unless prefs.has_key? :tests
    case prefs[:tests]
      when 'rspec'
        say_wizard "Adding DatabaseCleaner, FactoryGirl, Faker, Launchy, Selenium"
        prefs[:continuous_testing] = multiple_choice "Continuous testing?", [["None", "none"], ["Guard", "guard"]] unless prefs.has_key? :continuous_testing
      end
  end
end

## Front-end Framework
if recipes.include? 'frontend'
  prefs[:frontend] = multiple_choice "Front-end framework?", [["None", "none"],
    ["Bootstrap 3.0", "bootstrap3"], ["Bootstrap 2.3", "bootstrap2"],
    ["Zurb Foundation 5.0", "foundation5"], ["Zurb Foundation 4.0", "foundation4"],
    ["Simple CSS", "simple"]] unless prefs.has_key? :frontend
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
if recipes.include? 'models'
  prefs[:authentication] = multiple_choice "Authentication?", [["None", "none"], ["Devise", "devise"], ["OmniAuth", "omniauth"]] unless prefs.has_key? :authentication
  case prefs[:authentication]
    when 'devise'
      prefs[:devise_modules] = multiple_choice "Devise modules?", [["Devise with default modules","default"],
      ["Devise with Confirmable module","confirmable"]] unless prefs.has_key? :devise_modules
    when 'omniauth'
      prefs[:omniauth_provider] = multiple_choice "OmniAuth provider?", [["Facebook", "facebook"], ["Twitter", "twitter"], ["GitHub", "github"],
        ["LinkedIn", "linkedin"], ["Google-Oauth-2", "google_oauth2"], ["Tumblr", "tumblr"]] unless prefs.has_key? :omniauth_provider
  end
  unless prefs.has_key? :authorization
    if rails_4_1?
      prefs[:authorization] = multiple_choice "Authorization?", [["None", "none"], ["Pundit", "pundit"]]
    else
      prefs[:authorization] = multiple_choice "Authorization?", [["None", "none"], ["CanCan with Rolify", "cancan"]]
    end
  end
end

## Form Builder
prefs[:form_builder] = multiple_choice "Use a form builder gem?", [["None", "none"], ["SimpleForm", "simple_form"]] unless prefs.has_key? :form_builder

## MVC
if (recipes.include? 'models') && (recipes.include? 'controllers') && (recipes.include? 'views') && (recipes.include? 'routes')
  if (prefer :authorization, 'cancan') or (prefer :authorization, 'pundit')
    prefs[:starter_app] = multiple_choice "Install a starter app?", [["None", "none"], ["Home Page", "home_app"],
      ["Home Page, User Accounts", "users_app"], ["Home Page, User Accounts, Admin Dashboard", "admin_app"]] unless prefs.has_key? :starter_app
  elsif prefer :authentication, 'devise'
    prefs[:starter_app] = multiple_choice "Install a starter app?", [["None", "none"], ["Home Page", "home_app"],
      ["Home Page, User Accounts", "users_app"]] unless prefs.has_key? :starter_app
  elsif prefer :authentication, 'omniauth'
    prefs[:starter_app] = multiple_choice "Install a starter app?", [["None", "none"], ["Home Page", "home_app"],
      ["Home Page, User Accounts", "users_app"]] unless prefs.has_key? :starter_app
  else
    prefs[:starter_app] = multiple_choice "Install a starter app?", [["None", "none"], ["Home Page", "home_app"]] unless prefs.has_key? :starter_app
  end
end

# save diagnostics before anything can fail
create_file "README", "RECIPES\n#{recipes.sort.inspect}\n"
append_file "README", "PREFERENCES\n#{prefs.inspect}"

__END__

name: setup
description: "Make choices for your application."
author: RailsApps

run_after: [git, railsapps]
category: configuration
