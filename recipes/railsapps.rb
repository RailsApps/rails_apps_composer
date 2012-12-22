# Application template recipe for the rails_apps_composer. Change the recipe here:
# https://github.com/RailsApps/rails_apps_composer/blob/master/recipes/railsapps.rb

prefs[:railsapps] = multiple_choice "Install an example application?",
  [["I want to build my own application", "none"],
  ["membership/subscription/saas", "saas"],
  ["rails-prelaunch-signup", "rails-prelaunch-signup"],
  ["rails3-bootstrap-devise-cancan", "rails3-bootstrap-devise-cancan"],
  ["rails3-devise-rspec-cucumber", "rails3-devise-rspec-cucumber"],
  ["rails3-mongoid-devise", "rails3-mongoid-devise"],
  ["rails3-mongoid-omniauth", "rails3-mongoid-omniauth"],
  ["rails3-subdomains", "rails3-subdomains"]] unless prefs.has_key? :railsapps

case prefs[:railsapps]
  when 'saas'
    prefs[:railsapps] = multiple_choice "Billing with Stripe or Recurly?",
      [["Stripe", "rails-stripe-membership-saas"],
      ["Recurly", "rails-recurly-subscription-saas"]]
end

case prefs[:railsapps]
  when 'rails-stripe-membership-saas'
    prefs[:git] = true
    prefs[:database] = 'sqlite'
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
    prefs[:form_builder] = 'simple_form'
    prefs[:quiet_assets] = true
    prefs[:local_env_file] = true
    prefs[:better_errors] = true
  when 'rails-recurly-subscription-saas'
    prefs[:git] = true
    prefs[:database] = 'sqlite'
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
    prefs[:form_builder] = 'simple_form'
    prefs[:quiet_assets] = true
    prefs[:local_env_file] = true
    prefs[:better_errors] = true
  when 'rails-prelaunch-signup'
    prefs[:git] = true
    prefs[:database] = 'sqlite'
    prefs[:unit_test] = 'rspec'
    prefs[:integration] = 'cucumber'
    prefs[:fixtures] = 'factory_girl'
    prefs[:frontend] = 'bootstrap'
    prefs[:bootstrap] = 'sass'
    prefs[:email] = 'mandrill'
    prefs[:authentication] = 'devise'
    prefs[:devise_modules] = 'confirmable'
    prefs[:authorization] = 'cancan'
    prefs[:starter_app] = 'admin_app'
    prefs[:form_builder] = 'simple_form'
    prefs[:quiet_assets] = true
    prefs[:local_env_file] = true
    prefs[:better_errors] = true
    if prefer :git, true
      prefs[:prelaunch_branch] = multiple_choice "Git branch for the prelaunch app?", [["wip (work-in-progress)", "wip"], ["master", "master"], ["prelaunch", "prelaunch"], ["staging", "staging"]]
      if prefs[:prelaunch_branch] == 'master'
        prefs[:main_branch] = multiple_choice "Git branch for the main app?", [["None", "none"], ["wip (work-in-progress)", "wip"], ["edge", "edge"]]
      else
        prefs[:main_branch] = 'master'
      end
    end
  when 'rails3-bootstrap-devise-cancan'
    prefs[:git] = true
    prefs[:database] = 'sqlite'
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
    prefs[:form_builder] = 'simple_form'
    prefs[:quiet_assets] = true
    prefs[:local_env_file] = true
    prefs[:better_errors] = true
  when 'rails3-devise-rspec-cucumber'
    prefs[:git] = true
    prefs[:database] = 'sqlite'
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
    prefs[:quiet_assets] = true
    prefs[:local_env_file] = true
    prefs[:better_errors] = true
  when 'rails3-devise-rspec-cucumber-fabrication'
    prefs[:git] = true
    prefs[:database] = 'sqlite'
    prefs[:unit_test] = 'rspec'
    prefs[:integration] = 'cucumber'
    prefs[:fixtures] = 'fabrication'
    prefs[:frontend] = 'none'
    prefs[:email] = 'gmail'
    prefs[:authentication] = 'devise'
    prefs[:devise_modules] = 'default'
    prefs[:authorization] = 'none'
    prefs[:starter_app] = 'users_app'
    prefs[:form_builder] = 'none'
    prefs[:quiet_assets] = true
    prefs[:local_env_file] = true
    prefs[:better_errors] = true
  when 'rails3-mongoid-devise'
    prefs[:git] = true
    prefs[:database] = 'mongodb'
    prefs[:orm] = 'mongoid'
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
    prefs[:quiet_assets] = true
    prefs[:local_env_file] = true
    prefs[:better_errors] = true
  when 'rails3-mongoid-omniauth'
    prefs[:git] = true
    prefs[:database] = 'mongodb'
    prefs[:orm] = 'mongoid'
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
    prefs[:quiet_assets] = true
    prefs[:local_env_file] = true
    prefs[:better_errors] = true
  when 'rails3-subdomains'
    prefs[:git] = true
    prefs[:database] = 'mongodb'
    prefs[:orm] = 'mongoid'
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
    prefs[:quiet_assets] = true
    prefs[:local_env_file] = true
    prefs[:better_errors] = true
end

__END__

name: railsapps
description: "Install RailsApps example applications."
author: RailsApps

requires: [core]
run_after: [git]
category: configuration
