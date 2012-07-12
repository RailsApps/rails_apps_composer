# Application template recipe for the rails_apps_composer. Check for a newer version here:
# https://github.com/RailsApps/rails_apps_composer/blob/master/recipes/setup.rb

# Ruby on Rails
say_wizard "You are using Ruby version #{RUBY_VERSION}."
say_wizard "You are using Rails version #{Rails::VERSION::STRING}."

# Database
database = multiple_choice "Which database will you use?", [["SQLite", "sqlite"], ["MongoDB", "mongodb"]]
case database
	when 'sqlite'
    recipes << 'sqlite'
    recipes << 'activerecord'
  when 'mongodb'
    recipes << 'mongodb'
    orm = multiple_choice "How will you connect to MongoDB?", [["Mongoid","mongoid"]]
    recipes << orm
	else
		raise StandardError.new "No database selected."
end

# Template Engine
templating = multiple_choice "Which template engine?", [["ERB", "erb"], ["Haml", "haml"]]
case templating
	when 'erb'
    recipes << 'erb'
  when 'haml'
    recipes << 'haml'
	else
		raise StandardError.new "No template engine selected."
end

# Testing Framework
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
    recipes << fixtures
	else
		raise StandardError.new "No testing framework selected."
end

# Front-end Framework
frontend = multiple_choice "Which front-end framework?", [["None", "nothing"], ["Twitter Bootstrap (Sass)", "bootstrap_sass"], ["Twitter Bootstrap (Less)", "bootstrap_less"], ["Zurb Foundation", "foundation"], ["Skeleton", "skeleton"], ["Just normalize CSS for consistent styling", "normalize"]]
case frontend
  when 'bootstrap_sass'
    recipes << 'bootstrap_sass'
  when 'bootstrap_less'
    recipes << 'bootstrap_less'
  when 'foundation'
    recipes << 'foundation'
  when 'skeleton'
    recipes << 'skeleton'
  when 'normalize'
    recipes << 'normalize'
end

# Form Builder
form_builder = multiple_choice "Which form builder?", [["None", "none"], ["SimpleForm", "simple_form"]]
case form_builder
  when 'simple_form'
    recipes << 'simple_form'
end

# Email
email = yes_wizard? "Will the application send email?"
if email
  recipes << 'email'
  email_account = multiple_choice "What type of account for email?", [["SMTP","smtp"], ["Gmail","gmail"], ["SendGrid","sendgrid"], ["Mandrill","mandrill"]]
  recipes << email_account
end

# Authentication and Authorization
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
case authorization
  when 'cancan'
    recipes << 'cancan'
end

# MVC
homepage = yes_wizard? "Add a home page and controller?"
if homepage
  recipes << 'homepage'
end

__END__

name: setup
description: "Make choices for your application."
author: RailsApps

category: other
tags: [utilities, configuration]
