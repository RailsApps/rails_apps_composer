# Application template recipe for the rails_apps_composer. Change the recipe here:
# https://github.com/RailsApps/rails_apps_composer/blob/master/recipes/railsapps.rb

prefs[:railsapps] = multiple_choice "Install an example application?", 
  [["let me build my own application", "none"], 
  ["rails3-bootstrap-devise-cancan", "rails3-bootstrap-devise-cancan"], 
  ["rails3-devise-rspec-cucumber", "rails3-devise-rspec-cucumber"], 
  ["rails3-mongoid-devise", "rails3-mongoid-devise"],
  ["rails3-mongoid-omniauth", "rails3-mongoid-omniauth"],
  ["rails3-subdomains", "rails3-subdomains"]] unless prefs.has_key? :railsapps

case prefs[:railsapps]
  when 'rails3-bootstrap-devise-cancan'
    prefs[:git] = true
    prefs[:database] = 'sqlite'
    prefs[:templates] = 'erb'
    prefs[:unit_test] = 'rspec'
    prefs[:integration] = 'cucumber'
    prefs[:fixtures] = 'factory_girl'
    prefs[:frontend] = 'bootstrap'
    prefs[:bootstrap] = 'sass'
    prefs[:email] = 'gmail'
    prefs[:authentication] = 'devise'
    prefs[:devise_modules] = 'default'
    prefs[:authorization] = 'cancan'
    prefs[:starter_app] = 'admin_app'
    prefs[:form_builder] = 'none'
  when 'rails3-devise-rspec-cucumber'
    prefs[:git] = true
    prefs[:database] = 'sqlite'
    prefs[:templates] = 'erb'
    prefs[:unit_test] = 'rspec'
    prefs[:integration] = 'cucumber'
    prefs[:fixtures] = 'factory_girl'
    prefs[:frontend] = 'none'
    prefs[:email] = 'gmail'
    prefs[:authentication] = 'devise'
    prefs[:devise_modules] = 'default'
    prefs[:authorization] = 'none'
    prefs[:starter_app] = 'users_app'
    prefs[:form_builder] = 'none'
  when 'rails3-mongoid-devise'
    prefs[:git] = true
    prefs[:database] = 'mongodb'
    prefs[:orm] = 'mongoid'
    prefs[:templates] = 'erb'
    prefs[:unit_test] = 'rspec'
    prefs[:integration] = 'cucumber'
    prefs[:fixtures] = 'factory_girl'
    prefs[:frontend] = 'none'
    prefs[:email] = 'gmail'
    prefs[:authentication] = 'devise'
    prefs[:devise_modules] = 'default'
    prefs[:authorization] = 'none'
    prefs[:starter_app] = 'users_app'
    prefs[:form_builder] = 'none'
  when 'rails3-mongoid-omniauth'
    prefs[:git] = true
    prefs[:database] = 'mongodb'
    prefs[:orm] = 'mongoid'
    prefs[:templates] = 'erb'
    prefs[:unit_test] = 'rspec'
    prefs[:integration] = 'cucumber'
    prefs[:fixtures] = 'factory_girl'
    prefs[:frontend] = 'none'
    prefs[:email] = 'none'
    prefs[:authentication] = 'omniauth'
    prefs[:omniauth_provider] = 'twitter'
    prefs[:authorization] = 'none'
    prefs[:starter_app] = 'users_app'
    prefs[:form_builder] = 'none'
  when 'rails3-subdomains'
    prefs[:git] = true
    prefs[:database] = 'mongodb'
    prefs[:orm] = 'mongoid'
    prefs[:templates] = 'haml'
    prefs[:unit_test] = 'rspec'
    prefs[:integration] = 'cucumber'
    prefs[:fixtures] = 'factory_girl'
    prefs[:frontend] = 'none'
    prefs[:email] = 'gmail'
    prefs[:authentication] = 'devise'
    prefs[:devise_modules] = 'default'
    prefs[:authorization] = 'none'
    prefs[:starter_app] = 'subdomains_app'
    prefs[:form_builder] = 'none'
end

__END__

name: railsapps
description: "Install RailsApps example applications."
author: RailsApps

requires: [auth, controllers, email, extras, frontend, gems, git, init, models, readme, routes, setup, testing, views]
run_after: [git]
category: configuration
