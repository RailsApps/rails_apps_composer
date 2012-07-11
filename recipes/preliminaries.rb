# Application template recipe for the rails_apps_composer. Check for a newer version here:
# https://github.com/RailsApps/rails_apps_composer/blob/master/recipes/preliminaries.rb

case config['ruby']
	when 'ruby_1_9_3'
    recipes << 'ruby_1_9_3'
	else
		raise StandardError.new "Aborted. Only Ruby 1.9.3 is supported."
end

case config['rails']
	when 'rails_3_2_6'
    recipes << 'rails_3_2_6'
	else
		raise StandardError.new "Aborted. Only Rails 3.2.6 is supported."
end

case config['database']
	when 'sqlite'
    recipes << 'sqlite'
    orm = multiple_choice("How will you connect to SQLite?", [["ActiveRecord","activerecord"]])
    recipes << orm
  when 'mongodb'
    recipes << 'mongodb'
    orm = multiple_choice("How will you connect to MongoDB?", [["Mongoid","mongoid"]])
    recipes << orm
	else
		raise StandardError.new "No database selected."
end

case config['templating']
	when 'erb'
    recipes << 'erb'
  when 'haml'
    recipes << 'haml'
	else
		raise StandardError.new "No template engine selected."
end

case config['testing']
	when 'test_unit'
    recipes << 'test_unit'
  when 'rspec'
    recipes << 'rspec'
  when 'rspec_cucumber'
    recipes << 'rspec'
    recipes << 'cucumber'
    fixtures = multiple_choice("Fixture replacement?", [["None","none"], ["Factory Girl","factory_girl"], ["Machinist","machinist"]])
    recipes << fixtures
	else
		raise StandardError.new "No testing framework selected."
end

case config['frontend']
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

case config['forms']
  when 'simple_form'
    recipes << 'simple_form'
end

if config['email']
  recipes << 'email'
  email = multiple_choice("What type of account?", [["SMTP","smtp"], ["Gmail","gmail"], ["SendGrid","sendgrid"], ["Mandrill","mandrill"]])
  recipes << email
end

case config['authentication']
  when 'devise'
    recipes << 'devise'
    devise_modules = multiple_choice("Which Devise modules?", [["Devise with default modules","devise-standard"], ["Devise with Confirmable module","devise-confirmable"], ["Devise with Confirmable and Invitable modules","devise-invitable"]])
    case config['devise_modules']
      when 'confirmable'
        recipes << 'devise-confirmable'
      when 'invitable'
        recipes << 'devise-confirmable'
        recipes << 'devise-invitable'
    end
    authorization = yes_wizard?("Add CanCan for authorization?")
    recipes << 'cancan' if config['authorization']
  when 'omniauth'
    recipes << 'omniauth'
    omniauth_provider = multiple_choice("Which OmniAuth provider?", [["Twitter", twitter], ["Facebook", facebook], ["GitHub", github], ["LinkedIn", linkedin], ["Google-Oauth-2",google-oauth2], ["Tumblr", tumblr]])
    recipes << omniauth_provider
end

if config['homepage']
  recipes << homepage
end

__END__

name: Preliminaries
description: "Make choices for your application."
author: RailsApps

category: other
tags: [utilities, configuration]

config:
  - ruby:
      type: multiple_choice
      prompt: "Ruby version?"
      choices: [["Ruby 1.9.3", ruby_1_9_3]]
  - rails:
      type: multiple_choice
      prompt: "Rails version?"
      choices: [["Rails 3.2.6", rails_3_2_6]]
  - database:
      type: multiple_choice
      prompt: "Database?"
      choices: [["SQLite", sqlite], ["MongoDB", mongodb]]
  - templating:
      type: multiple_choice
      prompt: "Template engine?"
      choices: [["ERB", erb], ["Haml", haml]]
  - testing:
      type: multiple_choice
      prompt: "Testing framework?"
      choices: [["Test::Unit", test_unit], ["RSpec with Capybara", rspec], ["RSpec with Capybara and Cucumber", rspec_cucumber]]
  - frontend:
      type: multiple_choice
      prompt: "Front-end framework?"
      choices: [["None", nothing], ["Twitter Bootstrap (Sass)", bootstrap_sass], ["Twitter Bootstrap (Less)", bootstrap_less], ["Zurb Foundation", foundation], ["Skeleton", skeleton], ["Just normalize CSS for consistent styling", normalize]]
  - forms:
      type: multiple_choice
      prompt: "Form builder?"
      choices: [["None", none], ["SimpleForm", simple_form]]
  - email:
      type: boolean
      prompt: "Will the application send email?"
  - authentication:
      type: multiple_choice
      prompt: "Authentication?"
      choices: [["None", none], ["Devise", devise], ["OmniAuth", omniauth]]
  - homepage:
      type: boolean
      prompt: "Add a simple Home page and controller?"
