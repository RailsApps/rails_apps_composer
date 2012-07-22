# Application template recipe for the rails_apps_composer. Change the recipe here:
# https://github.com/RailsApps/rails_apps_composer/blob/master/recipes/routes.rb

after_bundler do
  say_wizard "recipe running after 'bundle install'"
  ### HOME ###
  if recipes.include? 'simple_home'
    remove_file 'public/index.html'
    gsub_file 'config/routes.rb', /get \"home\/index\"/, 'root :to => "home#index"'
  end
  ### USER_ACCOUNTS ###
  if recipes.include? 'user_accounts'
    ## DEVISE
    copy_from_repo 'config/routes.rb', :repo => 'https://raw.github.com/RailsApps/rails3-devise-rspec-cucumber/master/' if recipes.include? 'devise'
    ## OMNIAUTH
    copy_from_repo 'config/routes.rb', :repo => 'https://raw.github.com/RailsApps/rails3-mongoid-omniauth/master/' if recipes.include? 'omniauth'
  end
  ### SUBDOMAINS ###
  copy_from_repo 'lib/subdomain.rb', :repo => 'https://raw.github.com/RailsApps/rails3-subdomains/master/' if recipes.include? 'subdomains'
  copy_from_repo 'config/routes.rb', :repo => 'https://raw.github.com/RailsApps/rails3-subdomains/master/' if recipes.include? 'subdomains'
  ### CORRECT APPLICATION NAME ###
  gsub_file 'config/routes.rb', /^.*.routes.draw do/, "#{app_const}.routes.draw do"
  ### GIT ###
  git :add => '.' if recipes.include? 'git'
  git :commit => "-aqm 'rails_apps_composer: routes'" if recipes.include? 'git'
end # after_bundler

__END__

name: routes
description: "Add routes needed for starter apps."
author: RailsApps

run_after: [controllers]
category: other
tags: [utilities, configuration]