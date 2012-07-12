# Application template recipe for the rails_apps_composer. Check for a newer version here:
# https://github.com/RailsApps/rails_apps_composer/blob/master/recipes/readme.rb

# remove default READMEs
%w{
  README
  README.rdoc
  doc/README_FOR_APP
}.each { |file| remove_file file }

# add placeholder READMEs
get "https://raw.github.com/RailsApps/rails3-application-templates/master/files-v2/readme/readme.txt", "README"
get "https://raw.github.com/RailsApps/rails3-application-templates/master/files-v2/readme/readme.textile", "README.textile"
gsub_file "README", /App_Name/, "#{app_name.humanize.titleize}"
gsub_file "README.textile", /App_Name/, "#{app_name.humanize.titleize}"

# Ruby on Rails
gsub_file "README.textile", /\* Ruby/, "* Ruby version #{RUBY_VERSION}"
gsub_file "README.textile", /\* Rails/, "* Rails version #{Rails::VERSION::STRING}"

# Database
gsub_file "README.textile", /SQLite/, "MongoDB" if recipes.include? 'mongodb'
gsub_file "README.textile", /ActiveRecord/, "the Mongoid ORM" if recipes.include? 'mongoid'

# Template Engine
gsub_file "README.textile", /ERB/, "Haml" if recipes.include? 'haml'

# Testing Framework
gsub_file "README.textile", /Test::Unit/, "RSpec" if recipes.include? 'rspec'
gsub_file "README.textile", /RSpec/, "RSpec and Cucumber" if recipes.include? 'cucumber'
gsub_file "README.textile", /RSpec/, "RSpec and Factory Girl" if recipes.include? 'factory_girl'
gsub_file "README.textile", /RSpec/, "RSpec and Machinist" if recipes.include? 'machinist'

# Front-end Framework
gsub_file "README.textile", /Front-end Framework: None/, "Front-end Framework: Twitter Bootstrap (Sass)" if recipes.include? 'bootstrap_sass'
gsub_file "README.textile", /Front-end Framework: None/, "Front-end Framework: Twitter Bootstrap (Less)" if recipes.include? 'bootstrap_less'
gsub_file "README.textile", /Front-end Framework: None/, "Front-end Framework: Zurb Foundation" if recipes.include? 'foundation'
gsub_file "README.textile", /Front-end Framework: None/, "Front-end Framework: Skeleton" if recipes.include? 'skeleton'
gsub_file "README.textile", /Front-end Framework: None/, "Front-end Framework: Normalized CSS" if recipes.include? 'normalize'

# Form Builder
gsub_file "README.textile", /Form Builder: None/, "Form Builder: SimpleForm" if recipes.include? 'simple_form'
gsub_file "README.textile", /Form Builder: None/, "Form Builder: SimpleForm (Bootstrap)" if recipes.include? 'simple_form_bootstrap'

# Email
if recipes.include? 'email'
  gsub_file "README.textile", /Gmail/, "SMTP" if recipes.include? 'smtp'
  gsub_file "README.textile", /Gmail/, "SendGrid" if recipes.include? 'sendgrid'
  gsub_file "README.textile", /Gmail/, "Mandrill" if recipes.include? 'mandrill'
else
  gsub_file "README.textile", /h2. Email/, ""
  gsub_file "README.textile", /The application is configured to send email using a Gmail account./, ""
end

# Authentication and Authorization
gsub_file "README.textile", /Authentication: None/, "Authentication: Devise" if recipes.include? 'devise'
gsub_file "README.textile", /Authentication: None/, "Authentication: OmniAuth" if recipes.include? 'omniauth'
gsub_file "README.textile", /Authorization: None/, "Authorization: CanCan" if recipes.include? 'cancan'

__END__

name: Readme
description: "Build a README file for your application."
author: RailsApps

category: other
tags: [utilities, configuration]
