# Application template recipe for the rails_apps_composer. Change the recipe here:
# https://github.com/RailsApps/rails_apps_composer/blob/master/recipes/routes.rb

after_bundler do
  say_wizard "recipe running after 'bundle install'"
  ### HOME ###
  if prefer :starter_app, 'home_app'
    remove_file 'public/index.html'
    gsub_file 'config/routes.rb', /get \"home\/index\"/, 'root :to => "home#index"'
  end
  ### USER_ACCOUNTS ###
  if ['users_app','admin_app'].include? prefs[:starter_app]
    ## DEVISE
    copy_from_repo 'config/routes.rb', :repo => 'https://raw.github.com/RailsApps/rails3-devise-rspec-cucumber/master/' if prefer :authentication, 'devise'
    ## OMNIAUTH
    copy_from_repo 'config/routes.rb', :repo => 'https://raw.github.com/RailsApps/rails3-mongoid-omniauth/master/' if prefer :authentication, 'omniauth'
  end
  ### SUBDOMAINS ###
  copy_from_repo 'lib/subdomain.rb', :repo => 'https://raw.github.com/RailsApps/rails3-subdomains/master/' if prefer :starter_app, 'subdomains_app'
  copy_from_repo 'config/routes.rb', :repo => 'https://raw.github.com/RailsApps/rails3-subdomains/master/' if prefer :starter_app, 'subdomains_app'
  ### CORRECT APPLICATION NAME ###
  gsub_file 'config/routes.rb', /^.*.routes.draw do/, "#{app_const}.routes.draw do"
  ### GIT ###
  git :add => '-A' if prefer :git, true
  git :commit => '-qm "rails_apps_composer: routes"' if prefer :git, true
end # after_bundler

__END__

name: routes
description: "Add routes needed for starter apps."
author: RailsApps

requires: [setup, gems, models, controllers, views]
run_after: [setup, gems, models, controllers, views]
category: mvc