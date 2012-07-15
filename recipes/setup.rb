# Application template recipe for the rails_apps_composer. Check for a newer version here:
# https://github.com/RailsApps/rails_apps_composer/blob/master/recipes/setup.rb

## Ruby on Rails
say_wizard "You are using Ruby version #{RUBY_VERSION}."
say_wizard "You are using Rails version #{Rails::VERSION::STRING}."

## Database
database = multiple_choice "Which database will you use in development?", [["SQLite", "sqlite"], ["MongoDB", "mongodb"]]
case database
	when 'sqlite'
    recipes << 'sqlite'
    recipes << 'activerecord'
  when 'mongodb'
    recipes << 'mongodb'
    orm = multiple_choice "How will you connect to MongoDB?", [["Mongoid","mongoid"]]
    recipes << orm
end

## Template Engine
templating = multiple_choice "Which template engine?", [["ERB", "erb"], ["Haml", "haml"]]
case templating
	when 'erb'
    recipes << 'erb'
  when 'haml'
    recipes << 'haml'
end

## Testing Framework
testing = multiple_choice "Which testing framework?", [["Test::Unit", "test_unit"], ["RSpec with Capybara", "rspec"], ["RSpec with Capybara and Cucumber", "rspec_cucumber"]]
case testing
	when 'test_unit'
    recipes << 'test_unit'
  when 'rspec'
    recipes << 'rspec'
  when 'rspec_cucumber'
    recipes << 'rspec'
    recipes << 'cucumber'
    fixtures = multiple_choice "Fixture replacement?", [["None","none"], ["Factory Girl","factory_girl"], ["Machinist","machinist"]]
    recipes << fixtures unless fixtures == 'none'
end

## Front-end Framework
frontend = multiple_choice "Which front-end framework?", [["None", "none"], ["Twitter Bootstrap (Sass)", "bootstrap_sass"], ["Twitter Bootstrap (Less)", "bootstrap_less"], ["Zurb Foundation", "foundation"], ["Skeleton", "skeleton"], ["Just normalize CSS for consistent styling", "normalize"]]
recipes << frontend unless frontend == 'none'

## Form Builder
form_builder = multiple_choice "Which form builder?", [["None", "none"], ["SimpleForm", "simple_form"]]
recipes << form_builder unless form_builder == 'none'

## Email
email_account = multiple_choice "Add support for sending email?", [["None", "none"], ["SMTP","smtp"], ["Gmail","gmail"], ["SendGrid","sendgrid"], ["Mandrill","mandrill"]]
recipes << 'email' unless email_account == 'none'
recipes << email_account unless email_account == 'none'

## Authentication and Authorization
authentication = multiple_choice "Add authentication?", [["None", "none"], ["Devise", "devise"], ["OmniAuth", "omniauth"]]
case authentication
  when 'devise'
    recipes << 'devise'
    devise_modules = multiple_choice "Which Devise modules?", [["Devise with default modules","devise-standard"], ["Devise with Confirmable module","devise-confirmable"], ["Devise with Confirmable and Invitable modules","devise-invitable"]]
    case devise_modules
      when 'confirmable'
        recipes << 'devise-confirmable'
      when 'invitable'
        recipes << 'devise-confirmable'
        recipes << 'devise-invitable'
    end
  when 'omniauth'
    recipes << 'omniauth'
    omniauth_provider = multiple_choice "Which OmniAuth provider?", [["Twitter", "twitter"], ["Facebook", "facebook"], ["GitHub", "github"], ["LinkedIn", "linkedin"], ["Google-Oauth-2", "google-oauth2"], ["Tumblr", "tumblr"]]
    recipes << omniauth_provider
end
authorization = multiple_choice "Add authorization?", [["None", "none"], ["CanCan with Rolify", "cancan"]]
recipes << authorization unless authorization == 'none'

## MVC
if recipes.include? 'cancan'
  starterapp = multiple_choice "Install a starter app?", [["None", "none"], ["Home Page", "home_page"], ["Home Page, User Accounts", "users_page"], ["Home Page, User Accounts, Admin Dashboard", "admin_page"]]
elsif (recipes.include? 'devise') || (recipes.include? 'omniauth')
  starterapp = multiple_choice "Install a starter app?", [["None", "none"], ["Home Page", "home_page"], ["Home Page, User Accounts", "users_page"]]
else
  starterapp = multiple_choice "Install a starter app?", [["None", "none"], ["Home Page", "home_page"]]
end
recipes << starterapp unless starterapp == 'none'
if (recipes.include? 'devise') && (recipes.include? 'cancan')
  railsapp = multiple_choice "Install a ready-made application?", [["None", "none"], ["Prelaunch Signup App", "prelaunch_app"]]
end
recipes << railsapp unless railsapp == 'none'

__END__

name: setup
description: "Make choices for your application."
author: RailsApps

category: other
tags: [utilities, configuration]
