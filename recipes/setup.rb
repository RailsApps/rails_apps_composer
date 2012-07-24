# Application template recipe for the rails_apps_composer. Change the recipe here:
# https://github.com/RailsApps/rails_apps_composer/blob/master/recipes/setup.rb

## Ruby on Rails
say_wizard "You are using Ruby version #{RUBY_VERSION}."
say_wizard "You are using Rails version #{Rails::VERSION::STRING}."

## Git
say_wizard "initialize git"
recipes << 'git'
if recipes.include? 'git'
  begin
    remove_file '.gitignore'
    get 'https://raw.github.com/RailsApps/rails3-application-templates/master/files/gitignore.txt', '.gitignore'
  rescue OpenURI::HTTPError
    say_wizard "Unable to obtain gitignore file from the repo"
  end
  git :init
  git :add => '.'
  git :commit => "-aqm 'rails_apps_composer: initial commit'"
end

## Is sqlite3 in the Gemfile?
f = File.open(destination_root() + '/Gemfile', "r")
gemfile = ''
f.each_line do |line|
  gemfile += line
end
sqlite_detected = gemfile.include? 'sqlite3'

## Web Server
dev_webserver = multiple_choice "Web server for development?", [["WEBrick (default)", "webrick"], 
  ["Thin", "thin-development"], ["Unicorn", "unicorn-development"], ["Puma", "puma-development"]]
recipes << dev_webserver
prod_webserver = multiple_choice "Web server for production?", [["Same as development", "same"], 
  ["Thin", "thin-production"], ["Unicorn", "unicorn-development"], ["Puma", "puma-production"]]
if dev_webserver == 'same'
  case prod_webserver
    when 'thin-development'
      recipes << 'thin-production'
    when 'unicorn-development'
      recipes << 'unicorn-production'
    when 'puma-development'
      recipes << 'puma-production'
  end
else
  recipes << prod_webserver
end

## Database Adapter
database = multiple_choice "Database used in development?", [["SQLite", "sqlite"], ["PostgreSQL", "postgresql"], ["MySQL", "mysql"], ["MongoDB", "mongodb"]]
recipes << database
case database
  when 'mongodb'
    unless sqlite_detected
      orm = multiple_choice "How will you connect to MongoDB?", [["Mongoid","mongoid"]]
      recipes << orm
    else
      raise StandardError.new "SQLite detected in the Gemfile. Use '-O' or '--skip-activerecord' as in 'rails new foo -O' if you don't want ActiveRecord and SQLite"
    end
end

## Template Engine
templating = multiple_choice "Template engine?", [["ERB", "erb"], ["Haml", "haml"]]
case templating
	when 'erb'
    recipes << 'erb'
  when 'haml'
    recipes << 'haml'
end

## Testing Framework
if recipes.include? 'testing'
  testing = multiple_choice "Testing framework?", [["Test::Unit", "test_unit"], ["RSpec with Capybara and Cucumber", "cucumber"], ["RSpec with Capybara and Turnip", "turnip"], ["RSpec with Capybara", "rspec"]]
  recipes << testing
  recipes << 'rspec' if (testing == 'cucumber') || (testing == 'turnip')
  fixtures = multiple_choice "Fixture replacement?", [["None","none"], ["Factory Girl","factory_girl"], ["Machinist","machinist"]]
  recipes << fixtures unless fixtures == 'none'
end

## Front-end Framework
if recipes.include? 'frontend'
  frontend = multiple_choice "Front-end framework?", [["None", "none"], ["Twitter Bootstrap (Sass)", "bootstrap-sass"], ["Twitter Bootstrap (Less)", "bootstrap-less"], ["Zurb Foundation", "foundation"], ["Skeleton", "skeleton"], ["Just normalize CSS for consistent styling", "normalize"]]
  recipes << frontend unless frontend == 'none'
  if (recipes.include? 'bootstrap-sass') || (recipes.include? 'bootstrap-less')
    recipes << 'bootstrap'
  end
end

## Form Builder
form_builder = multiple_choice "Form builder?", [["None", "none"], ["SimpleForm", "simple_form"]]
recipes << form_builder unless form_builder == 'none'

## Email
if recipes.include? 'email'
  email_account = multiple_choice "Add support for sending email?", [["None", "none"], ["Gmail","gmail"], ["SMTP","smtp"], ["SendGrid","sendgrid"], ["Mandrill","mandrill"]]
  recipes << email_account unless email_account == 'none'
  recipes.delete('email') if email_account == 'none'
end

## Authentication and Authorization
if recipes.include? 'auth'
  authentication = multiple_choice "Authentication?", [["None", "none"], ["Devise", "devise"], ["OmniAuth", "omniauth"]]
  case authentication
    when 'devise'
      recipes << 'devise'
      if recipes.include? 'mongodb'
        devise_modules = multiple_choice "Devise modules?", [["Devise with default modules","devise-standard"]]
      else
        devise_modules = multiple_choice "Devise modules?", [["Devise with default modules","devise-standard"], ["Devise with Confirmable module","devise-confirmable"], ["Devise with Confirmable and Invitable modules","devise-invitable"]]
      end
      case devise_modules
        when 'confirmable'
          recipes << 'devise-confirmable'
        when 'invitable'
          recipes << 'devise-confirmable'
          recipes << 'devise-invitable'
      end
    when 'omniauth'
      recipes << 'omniauth'
      omniauth_provider = multiple_choice "OmniAuth provider?", [["Facebook", "facebook"], ["Twitter", "twitter"], ["GitHub", "github"], ["LinkedIn", "linkedin"], ["Google-Oauth-2", "google-oauth2"], ["Tumblr", "tumblr"]]
      recipes << omniauth_provider
  end
  authorization = multiple_choice "Authorization?", [["None", "none"], ["CanCan with Rolify", "cancan"]]
  recipes << authorization unless authorization == 'none'
end

## MVC
if (recipes.include? 'models') && (recipes.include? 'controllers') && (recipes.include? 'views') && (recipes.include? 'routes')
  if recipes.include? 'cancan'
    starterapp = multiple_choice "Install a starter app?", [["None", "none"], ["Home Page", "simple_home"], 
      ["Home Page, User Accounts", "user_accounts"], 
      ["Home Page, User Accounts, Admin Dashboard", "admin_dashboard"]]
  elsif recipes.include? 'devise'
    if recipes.include? 'mongoid'
      starterapp = multiple_choice "Install a starter app?", [["None", "none"], ["Home Page", "simple_home"], 
        ["Home Page, User Accounts", "user_accounts"], 
        ["Home Page, User Accounts, Subdomains", "subdomains"]]
    else
      starterapp = multiple_choice "Install a starter app?", [["None", "none"], ["Home Page", "simple_home"], 
        ["Home Page, User Accounts", "user_accounts"]]
    end
  elsif recipes.include? 'omniauth'
    starterapp = multiple_choice "Install a starter app?", [["None", "none"], ["Home Page", "simple_home"], 
      ["Home Page, User Accounts", "user_accounts"]]
  else
    starterapp = multiple_choice "Install a starter app?", [["None", "none"], ["Home Page", "simple_home"]]
  end
  recipes << starterapp unless starterapp == 'none'
  recipes << 'simple_home' if (starterapp == 'user_accounts') || (starterapp == 'admin_dashboard') || (starterapp == 'subdomains')
  recipes << 'user_accounts' if (starterapp == 'admin_dashboard' )|| (starterapp == 'subdomains')
  if (recipes.include? 'prelaunch') && (recipes.include? 'devise') && (recipes.include? 'cancan')
    prelaunch_app = multiple_choice "Install a prelaunch app?", [["None", "none"], ["Prelaunch Signup App", "signup_app"]]
    if prelaunch_app == 'signup_app'
      recipes << 'signup_app'
      recipes << 'devise-confirmable'
      bulkmail = multiple_choice "Send news and announcements with a mail service?", [["None", "none"], ["MailChimp","mailchimp"]]
      recipes << bulkmail unless bulkmail == 'none'
      if recipes.include? 'git'
        prelaunch_branch = multiple_choice "Git branch for the prelaunch app?", [["wip (work-in-progress)", "wip"], ["master", "master"], ["prelaunch", "prelaunch"], ["staging", "staging"]]
        if prelaunch_branch == 'master'
          main_branch = multiple_choice "Git branch for the main app?", [["None (delete)", "none"], ["wip (work-in-progress)", "wip"], ["edge", "edge"]]
        end
      end
    end
  end
end

__END__

name: setup
description: "Make choices for your application."
author: RailsApps

category: other
tags: [utilities, configuration]
