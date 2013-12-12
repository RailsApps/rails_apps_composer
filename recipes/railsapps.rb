# Application template recipe for the rails_apps_composer. Change the recipe here:
# https://github.com/RailsApps/rails_apps_composer/blob/master/recipes/railsapps.rb

raise if (defined? defaults) || (defined? preferences) # Shouldn't happen.
if options[:verbose]
  print "\nrecipes: ";p recipes
  print "\ngems: "   ;p gems
  print "\nprefs: "  ;p prefs
  print "\nconfig: " ;p config
end

case Rails::VERSION::MAJOR.to_s
when "3"
  prefs[:railsapps] = multiple_choice "Install an example application for Rails 3.2?",
    [["I want to build my own application", "none"],
    ["membership/subscription/saas", "saas"],
    ["rails-prelaunch-signup", "rails-prelaunch-signup"],
    ["rails3-bootstrap-devise-cancan", "rails3-bootstrap-devise-cancan"],
    ["rails3-devise-rspec-cucumber", "rails3-devise-rspec-cucumber"],
    ["rails3-mongoid-devise", "rails3-mongoid-devise"],
    ["rails3-mongoid-omniauth", "rails3-mongoid-omniauth"],
    ["rails3-subdomains", "rails3-subdomains"]] unless prefs.has_key? :railsapps
when "4"
  prefs[:apps4] = multiple_choice "Install an example application for Rails 4.0?",
    [["Build a RailsApps starter application", "railsapps"],
    ["Build a contributed application", "contributed_app"],
    ["I want to build my own application", "none"]] unless prefs.has_key? :apps4
  case prefs[:apps4]
    when 'railsapps'
      prefs[:apps4] = multiple_choice "Starter apps for Rails 4.0. More to come.",
        [["learn-rails", "learn-rails"],
        ["rails-bootstrap", "rails-bootstrap"]]
    when 'contributed_app'
      prefs[:apps4] = multiple_choice "No contributed applications are available.",
        [["continue", "none"]]
  end
end

case prefs[:apps4]
  when 'simple-test'
    prefs[:dev_webserver] = 'webrick'
    prefs[:prod_webserver] = 'same'
    prefs[:templates] = 'erb'
    prefs[:git] = false
    prefs[:github] = false
    prefs[:database] = 'sqlite'
    prefs[:unit_test] = false
    prefs[:integration] = false
    prefs[:fixtures] = false
    prefs[:frontend] = false
    prefs[:email] = false
    prefs[:authentication] = false
    prefs[:devise_modules] = false
    prefs[:authorization] = false
    prefs[:starter_app] = false
    prefs[:form_builder] = false
    prefs[:quiet_assets] = false
    prefs[:local_env_file] = false
    prefs[:better_errors] = false
    prefs[:ban_spiders] = false
    prefs[:continuous_testing] = false
  when 'learn-rails'
    prefs[:git] = true
    prefs[:database] = 'default'
    prefs[:unit_test] = false
    prefs[:integration] = false
    prefs[:fixtures] = false
    prefs[:frontend] = 'foundation4'
    prefs[:email] = 'gmail'
    prefs[:authentication] = false
    prefs[:devise_modules] = false
    prefs[:authorization] = false
    prefs[:starter_app] = false
    prefs[:form_builder] = 'simple_form'
    prefs[:quiet_assets] = true
    prefs[:local_env_file] = true
    prefs[:better_errors] = true
  when 'rails-bootstrap'
    prefs[:git] = true
    prefs[:database] = 'default'
    prefs[:unit_test] = false
    prefs[:integration] = false
    prefs[:fixtures] = false
    prefs[:frontend] = 'bootstrap3'
    prefs[:email] = 'none'
    prefs[:authentication] = false
    prefs[:devise_modules] = false
    prefs[:authorization] = false
    prefs[:starter_app] = false
    prefs[:form_builder] = 'simple_form'
    prefs[:quiet_assets] = true
    prefs[:local_env_file] = true
    prefs[:better_errors] = true
end

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
    prefs[:frontend] = 'bootstrap2'
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
    prefs[:frontend] = 'bootstrap2'
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
    prefs[:frontend] = 'bootstrap2'
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
      prefs[:prelaunch_branch] = multiple_choice "Git branch for the prelaunch app?",
        [["wip (work-in-progress)", "wip"],
        ["master", "master"],
        ["prelaunch", "prelaunch"],
        ["staging", "staging"]] unless prefs.has_key? :prelaunch_branch

      prefs[:main_branch] = unless 'master' == prefs[:prelaunch_branch]
        'master'
      else
        multiple_choice "Git branch for the main app?",
          [["None", "none"],
          ["wip (work-in-progress)", "wip"],
          ["edge", "edge"]]
      end unless prefs.has_key? :main_branch
    end
  when 'rails3-bootstrap-devise-cancan'
    prefs[:git] = true
    prefs[:database] = 'sqlite'
    prefs[:unit_test] = 'rspec'
    prefs[:integration] = 'cucumber'
    prefs[:fixtures] = 'factory_girl'
    prefs[:frontend] = 'bootstrap2'
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
