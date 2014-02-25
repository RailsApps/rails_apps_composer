# Application template recipe for the rails_apps_composer. Change the recipe here:
# https://github.com/RailsApps/rails_apps_composer/blob/master/recipes/readme.rb

after_everything do
  say_wizard "recipe running after everything"

  # remove default READMEs
  %w{
    README
    README.rdoc
    doc/README_FOR_APP
  }.each { |file| remove_file file }

  # add placeholder READMEs and humans.txt file
  copy_from_repo 'public/humans.txt'
  copy_from_repo 'README'
  copy_from_repo 'README.md'
  gsub_file "README", /App_Name/, "#{app_name.humanize.titleize}"
  gsub_file "README.md", /App_Name/, "#{app_name.humanize.titleize}"

  # Diagnostics
  gsub_file "README.md", /recipes that are known/, "recipes that are NOT known" if diagnostics[:recipes] == 'fail'
  gsub_file "README.md", /preferences that are known/, "preferences that are NOT known" if diagnostics[:prefs] == 'fail'
  print_recipes = recipes.sort.map { |r| "\n* #{r}" }.join('')
  print_preferences = prefs.map { |k, v| "\n* #{k}: #{v}" }.join('')
  gsub_file "README.md", /RECIPES/, print_recipes
  gsub_file "README.md", /PREFERENCES/, print_preferences
  gsub_file "README", /RECIPES/, print_recipes
  gsub_file "README", /PREFERENCES/, print_preferences

  # Ruby on Rails
  gsub_file "README.md", /\* Ruby/, "* Ruby version #{RUBY_VERSION}"
  gsub_file "README.md", /\* Rails/, "* Rails version #{Rails::VERSION::STRING}"

  # Database
  gsub_file "README.md", /SQLite/, "PostgreSQL" if prefer :database, 'postgresql'
  gsub_file "README.md", /SQLite/, "MySQL" if prefer :database, 'mysql'
  gsub_file "README.md", /SQLite/, "MongoDB" if prefer :database, 'mongodb'
  gsub_file "README.md", /ActiveRecord/, "the Mongoid ORM" if prefer :orm, 'mongoid'

  # Template Engine
  gsub_file "README.md", /ERB/, "Haml" if prefer :templates, 'haml'
  gsub_file "README.md", /ERB/, "Slim" if prefer :templates, 'slim'

  # Testing Framework
  gsub_file "README.md", /Test::Unit/, "RSpec" if prefer :unit_test, 'rspec'
  gsub_file "README.md", /RSpec/, "RSpec and Cucumber" if prefer :integration, 'cucumber'
  gsub_file "README.md", /RSpec/, "RSpec and Factory Girl" if prefer :fixtures, 'factory_girl'
  gsub_file "README.md", /RSpec/, "RSpec and Machinist" if prefer :fixtures, 'machinist'

  # Front-end Framework
  gsub_file "README.md", /Front-end Framework: None/, "Front-end Framework: Bootstrap 2.3 (Sass)" if prefer :frontend, 'bootstrap2'
  gsub_file "README.md", /Front-end Framework: None/, "Front-end Framework: Bootstrap 3.0 (Sass)" if prefer :frontend, 'bootstrap3'
  gsub_file "README.md", /Front-end Framework: None/, "Front-end Framework: Zurb Foundation 4" if prefer :frontend, 'foundation4'
  gsub_file "README.md", /Front-end Framework: None/, "Front-end Framework: Zurb Foundation 5" if prefer :frontend, 'foundation5'

  # Form Builder
  gsub_file "README.md", /Form Builder: None/, "Form Builder: SimpleForm" if prefer :form_builder, 'simple_form'

  # Email
  unless prefer :email, 'none'
    gsub_file "README.md", /Gmail/, "SMTP" if prefer :email, 'smtp'
    gsub_file "README.md", /Gmail/, "SendGrid" if prefer :email, 'sendgrid'
    gsub_file "README.md", /Gmail/, "Mandrill" if prefer :email, 'mandrill'
    gsub_file "README.md", /Email delivery is disabled in development./, "Email delivery is configured via MailCatcher in development." if prefer :mailcatcher, true
    insert_into_file 'README.md', "\nEmail rendering in development enabled via MailView.", :after => /Email delivery is.*\n/ if prefer :mail_view, true
  else
    gsub_file "README.md", /Email/, ""
    gsub_file "README.md", /-----/, ""
    gsub_file "README.md", /The application is configured to send email using a Gmail account./, ""
    gsub_file "README.md", /Email delivery is disabled in development./, ""
  end

  # Authentication and Authorization
  gsub_file "README.md", /Authentication: None/, "Authentication: Devise" if prefer :authentication, 'devise'
  gsub_file "README.md", /Authentication: None/, "Authentication: OmniAuth" if prefer :authentication, 'omniauth'
  gsub_file "README.md", /Authorization: None/, "Authorization: CanCan" if prefer :authorization, 'cancan'

  # Admin
  gsub_file "README.md", /Admin: None/, "Admin: ActiveAdmin" if prefer :admin, 'activeadmin'
  gsub_file "README.md", /Admin: None/, "Admin: RailsAdmin" if prefer :admin, 'rails_admin'

  git :add => '-A' if prefer :git, true
  git :commit => '-qm "rails_apps_composer: add README files"' if prefer :git, true

end # after_everything

__END__

name: readme
description: "Build a README file for your application."
author: RailsApps

requires: [setup]
run_after: [setup]
category: configuration
