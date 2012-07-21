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
    get "https://raw.github.com/RailsApps/rails3-application-templates/master/files/gitignore.txt", ".gitignore"
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

## Database
database = multiple_choice "Which database will you use in development?", [["SQLite", "sqlite"], ["MongoDB", "mongodb"]]
case database
	when 'sqlite'
    recipes << 'sqlite'
    recipes << 'activerecord'
  when 'mongodb'
<<<<<<< HEAD
    recipes << 'mongodb'
    orm = multiple_choice "How will you connect to MongoDB?", [["Mongoid","mongoid"]]
    recipes << orm
=======
    unless sqlite_detected
      recipes << 'mongodb'
      orm = multiple_choice "How will you connect to MongoDB?", [["Mongoid","mongoid"]]
      recipes << orm
    else
      raise StandardError.new "SQLite detected in the Gemfile. Use '-O' or '--skip-activerecord' as in 'rails new foo -O' if you don't want ActiveRecord and SQLite"
    end
>>>>>>> wip
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
<<<<<<< HEAD
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
=======
if recipes.include? 'testing'
  testing = multiple_choice "Which testing framework?", [["RSpec with Capybara", "rspec"], ["RSpec with Capybara and Cucumber", "rspec_cucumber"], ["Test::Unit", "test_unit"]]
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
end

## Front-end Framework
if recipes.include? 'frontend'
  frontend = multiple_choice "Which front-end framework?", [["None", "none"], ["Twitter Bootstrap (Sass)", "bootstrap_sass"], ["Twitter Bootstrap (Less)", "bootstrap_less"], ["Zurb Foundation", "foundation"], ["Skeleton", "skeleton"], ["Just normalize CSS for consistent styling", "normalize"]]
  recipes << frontend unless frontend == 'none'
  if (recipes.include? 'bootstrap_sass') || (recipes.include? 'bootstrap_less')
    recipes << 'bootstrap'
  end
end
>>>>>>> wip

## Form Builder
form_builder = multiple_choice "Which form builder?", [["None", "none"], ["SimpleForm", "simple_form"]]
recipes << form_builder unless form_builder == 'none'

## Email
<<<<<<< HEAD
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
=======
if recipes.include? 'email'
  email_account = multiple_choice "Add support for sending email?", [["None", "none"], ["Gmail","gmail"], ["SMTP","smtp"], ["SendGrid","sendgrid"], ["Mandrill","mandrill"]]
  recipes << email_account unless email_account == 'none'
  recipes.delete('email') if email_account == 'none'
end

## Authentication and Authorization
if recipes.include? 'auth'
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
      omniauth_provider = multiple_choice "Which OmniAuth provider?", [["Facebook", "facebook"], ["Twitter", "twitter"], ["GitHub", "github"], ["LinkedIn", "linkedin"], ["Google-Oauth-2", "google-oauth2"], ["Tumblr", "tumblr"]]
      recipes << omniauth_provider
  end
  authorization = multiple_choice "Add authorization?", [["None", "none"], ["CanCan with Rolify", "cancan"]]
  recipes << authorization unless authorization == 'none'
end

## MVC
if (recipes.include? 'models') && (recipes.include? 'controllers') && (recipes.include? 'views') && (recipes.include? 'routes')
  if recipes.include? 'cancan'
    starterapp = multiple_choice "Install a starter app?", [["None", "none"], ["Home Page", "simple_home"], ["Home Page, User Accounts", "user_accounts"], ["Home Page, User Accounts, Admin Dashboard", "admin_dashboard"]]
  elsif (recipes.include? 'devise') || (recipes.include? 'omniauth')
    starterapp = multiple_choice "Install a starter app?", [["None", "none"], ["Home Page", "simple_home"], ["Home Page, User Accounts", "user_accounts"]]
  else
    starterapp = multiple_choice "Install a starter app?", [["None", "none"], ["Home Page", "simple_home"]]
  end
  recipes << starterapp unless starterapp == 'none'
  case starterapp
  	when 'user_accounts'
      recipes << 'simple_home'
    when 'admin_dashboard'
      recipes << 'user_accounts'
      recipes << 'simple_home'
  end
  if (recipes.include? 'devise') && (recipes.include? 'cancan')
    full_app = multiple_choice "Install a ready-made application?", [["None", "none"], ["Prelaunch Signup App", "prelaunch_app"]]
  end
  recipes << full_app unless full_app == 'none'
>>>>>>> wip
end
recipes << railsapp unless railsapp == 'none'

__END__

name: setup
description: "Make choices for your application."
author: RailsApps

category: other
tags: [utilities, configuration]
