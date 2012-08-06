# Application template recipe for the rails_apps_composer. Change the recipe here:
# https://github.com/RailsApps/rails_apps_composer/blob/master/recipes/readme.rb

# remove default READMEs
%w{
  README
  README.rdoc
  doc/README_FOR_APP
}.each { |file| remove_file file }

# add placeholder READMEs and humans.txt file
copy_from_repo 'public/humans.txt'
copy_from_repo 'README'
copy_from_repo 'README.textile'
gsub_file "README", /App_Name/, "#{app_name.humanize.titleize}"
gsub_file "README.textile", /App_Name/, "#{app_name.humanize.titleize}"

# Ruby on Rails
gsub_file "README.textile", /\* Ruby/, "* Ruby version #{RUBY_VERSION}"
gsub_file "README.textile", /\* Rails/, "* Rails version #{Rails::VERSION::STRING}"

# Database
gsub_file "README.textile", /SQLite/, "MongoDB" if prefer :database, 'mongodb'
gsub_file "README.textile", /ActiveRecord/, "the Mongoid ORM" if prefer :orm, 'mongoid'

# Template Engine
gsub_file "README.textile", /ERB/, "Haml" if prefer :templates, 'haml'
gsub_file "README.textile", /ERB/, "Slim" if prefer :templates, 'slim'

# Testing Framework
gsub_file "README.textile", /Test::Unit/, "RSpec" if prefer :unit_test, 'rspec'
gsub_file "README.textile", /RSpec/, "RSpec and Cucumber" if prefer :integration, 'cucumber'
gsub_file "README.textile", /RSpec/, "RSpec and Factory Girl" if prefer :fixtures, 'factory_girl'
gsub_file "README.textile", /RSpec/, "RSpec and Machinist" if prefer :fixtures, 'machinist'

# Front-end Framework
gsub_file "README.textile", /Front-end Framework: None/, "Front-end Framework: Twitter Bootstrap (Sass)" if prefer :bootstrap, 'sass'
gsub_file "README.textile", /Front-end Framework: None/, "Front-end Framework: Twitter Bootstrap (Less)" if prefer :bootstrap, 'less'
gsub_file "README.textile", /Front-end Framework: None/, "Front-end Framework: Zurb Foundation" if prefer :frontend, 'foundation'
gsub_file "README.textile", /Front-end Framework: None/, "Front-end Framework: Skeleton" if prefer :frontend, 'skeleton'
gsub_file "README.textile", /Front-end Framework: None/, "Front-end Framework: Normalized CSS" if prefer :frontend, 'normalize'

# Form Builder
gsub_file "README.textile", /Form Builder: None/, "Form Builder: SimpleForm" if prefer :form_builder, 'simple_form'

# Email
unless prefer :email, 'none'
  gsub_file "README.textile", /Gmail/, "SMTP" if prefer :email, 'smtp'
  gsub_file "README.textile", /Gmail/, "SendGrid" if prefer :email, 'sendgrid'
  gsub_file "README.textile", /Gmail/, "Mandrill" if prefer :email, 'mandrill'
else
  gsub_file "README.textile", /h2. Email/, ""
  gsub_file "README.textile", /The application is configured to send email using a Gmail account./, ""
end

# Authentication and Authorization
gsub_file "README.textile", /Authentication: None/, "Authentication: Devise" if prefer :authentication, 'devise'
gsub_file "README.textile", /Authentication: None/, "Authentication: OmniAuth" if prefer :authentication, 'omniauth'
gsub_file "README.textile", /Authorization: None/, "Authorization: CanCan" if prefer :authorization, 'cancan'

git :add => '.' if prefer :git, true
git :commit => "-aqm 'rails_apps_composer: add README files'" if prefer :git, true

__END__

name: readme
description: "Build a README file for your application."
author: RailsApps

requires: [setup]
run_after: [setup]
category: configuration
