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
  ["Thin", "thin"], ["Unicorn", "unicorn"], ["Puma", "puma"]] unless prefs.has_key? :dev_webserver
webserver = multiple_choice "Web server for production?", [["Same as development", "same"], 
  ["Thin", "thin"], ["Unicorn", "unicorn"], ["Puma", "puma"]] unless prefs.has_key? :prod_webserver
if webserver == 'same'
  case prefs[:dev_webserver]
    when 'thin'
      prefs[:prod_webserver] = 'thin'
    when 'unicorn'
      prefs[:prod_webserver] = 'unicorn'
    when 'puma'
      prefs[:prod_webserver] = 'puma'
  end
else
  prefs[:prod_webserver] = webserver
end

## Database Adapter
prefs[:database] = multiple_choice "Database used in development?", [["SQLite", "sqlite"], ["PostgreSQL", "postgresql"], 
  ["MySQL", "mysql"], ["MongoDB", "mongodb"]] unless prefs.has_key? :database
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
prefs[:templates] = multiple_choice "Template engine?", [["ERB", "erb"], ["Haml", "haml"], ["Slim (experimental)", "slim"]] unless prefs.has_key? :templates

## Testing Framework
if recipes.include? 'testing'
  prefs[:unit_test] = multiple_choice "Unit testing?", [["Test::Unit", "test_unit"], ["RSpec", "rspec"], ["MiniTest", "minitest"]] unless prefs.has_key? :unit_test
  prefs[:integration] = multiple_choice "Integration testing?", [["None", "none"], ["RSpec with Capybara", "rspec-capybara"], 
    ["Cucumber with Capybara", "cucumber"], ["Turnip with Capybara", "turnip"], ["MiniTest with Capybara", "minitest-capybara"]] unless prefs.has_key? :integration
  prefs[:fixtures] = multiple_choice "Fixture replacement?", [["None","none"], ["Factory Girl","factory_girl"], ["Machinist","machinist"], ["Fabrication","fabrication"]] unless prefs.has_key? :fixtures
end

## Front-end Framework
if recipes.include? 'frontend'
  prefs[:frontend] = multiple_choice "Front-end framework?", [["None", "none"], ["Twitter Bootstrap", "bootstrap"], 
    ["Zurb Foundation", "foundation"], ["Skeleton", "skeleton"], ["Just normalize CSS for consistent styling", "normalize"]] unless prefs.has_key? :frontend
  if prefer :frontend, 'bootstrap'
    case HOST_OS
      when /mswin|windows/i
        prefs[:bootstrap] = multiple_choice "Twitter Bootstrap version?", [["Twitter Bootstrap (Sass)", "sass"]] unless prefs.has_key? :bootstrap
      else
        prefs[:bootstrap] = multiple_choice "Twitter Bootstrap version?", [["Twitter Bootstrap (Less)", "less"],
          ["Twitter Bootstrap (Sass)", "sass"]] unless prefs.has_key? :bootstrap
    end
  end
end

## Email
if recipes.include? 'email'
  prefs[:email] = multiple_choice "Add support for sending email?", [["None", "none"], ["Gmail","gmail"], ["SMTP","smtp"], 
    ["SendGrid","sendgrid"], ["Mandrill","mandrill"]] unless prefs.has_key? :email
else
  prefs[:email] = 'none'
end

## Authentication and Authorization
if recipes.include? 'models'
  prefs[:authentication] = multiple_choice "Authentication?", [["None", "none"], ["Devise", "devise"], ["OmniAuth", "omniauth"]] unless prefs.has_key? :authentication
  case prefs[:authentication]
    when 'devise'
      if prefer :orm, 'mongoid'
        prefs[:devise_modules] = multiple_choice "Devise modules?", [["Devise with default modules","default"]] unless prefs.has_key? :devise_modules
      else
        prefs[:devise_modules] = multiple_choice "Devise modules?", [["Devise with default modules","default"], ["Devise with Confirmable module","confirmable"], 
          ["Devise with Confirmable and Invitable modules","invitable"]] unless prefs.has_key? :devise_modules
      end
    when 'omniauth'
      prefs[:omniauth_provider] = multiple_choice "OmniAuth provider?", [["Facebook", "facebook"], ["Twitter", "twitter"], ["GitHub", "github"], 
        ["LinkedIn", "linkedin"], ["Google-Oauth-2", "google_oauth2"], ["Tumblr", "tumblr"]] unless prefs.has_key? :omniauth_provider
  end
  prefs[:authorization] = multiple_choice "Authorization?", [["None", "none"], ["CanCan with Rolify", "cancan"]] unless prefs.has_key? :authorization
end

## Form Builder
prefs[:form_builder] = multiple_choice "Use a form builder gem?", [["None", "none"], ["SimpleForm", "simple_form"]] unless prefs.has_key? :form_builder

## MVC
if (recipes.include? 'models') && (recipes.include? 'controllers') && (recipes.include? 'views') && (recipes.include? 'routes')
  if prefer :authorization, 'cancan'
    prefs[:starter_app] = multiple_choice "Install a starter app?", [["None", "none"], ["Home Page", "home_app"], 
      ["Home Page, User Accounts", "users_app"], ["Home Page, User Accounts, Admin Dashboard", "admin_app"]] unless prefs.has_key? :starter_app
  elsif prefer :authentication, 'devise'
    if prefer :orm, 'mongoid'
      prefs[:starter_app] = multiple_choice "Install a starter app?", [["None", "none"], ["Home Page", "home_app"], 
        ["Home Page, User Accounts", "users_app"], ["Home Page, User Accounts, Subdomains", "subdomains_app"]] unless prefs.has_key? :starter_app
    else
      prefs[:starter_app] = multiple_choice "Install a starter app?", [["None", "none"], ["Home Page", "home_app"], 
        ["Home Page, User Accounts", "users_app"]] unless prefs.has_key? :starter_app
    end
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
