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
    if (prefer :authentication, 'devise') and (not prefer :apps4, 'rails-devise')
      copy_from_repo 'config/routes.rb', :repo => 'https://raw.github.com/RailsApps/rails3-devise-rspec-cucumber/master/'
      ## Rails 4.0 doesn't allow two 'root' routes
      gsub_file 'config/routes.rb', /authenticated :user do\n.*\n.*\n  /, '' if rails_4?
      ## accommodate strong parameters in Rails 4
      gsub_file 'config/routes.rb', /devise_for :users/, 'devise_for :users, :controllers => {:registrations => "registrations"}' if rails_4?
    end
    ## OMNIAUTH
    if prefer :authentication, 'omniauth'
      if rails_4?
        copy_from_repo 'config/routes.rb', :repo => 'https://raw.github.com/RailsApps/rails-omniauth/master/'
      else
        copy_from_repo 'config/routes.rb', :repo => 'https://raw.github.com/RailsApps/rails3-mongoid-omniauth/master/'
      end
    end
  end
  ### SUBDOMAINS ###
  copy_from_repo 'lib/subdomain.rb', :repo => 'https://raw.github.com/RailsApps/rails3-subdomains/master/' if prefer :starter_app, 'subdomains_app'
  copy_from_repo 'config/routes.rb', :repo => 'https://raw.github.com/RailsApps/rails3-subdomains/master/' if prefer :starter_app, 'subdomains_app'
  if rails_4_1?
    # replaces application name copied from rails3-devise-rspec-cucumber repo
    gsub_file 'config/routes.rb', /^.*.routes.draw do/, "Rails.application.routes.draw do"
  else
    # correct application name
    gsub_file 'config/routes.rb', /^.*.routes.draw do/, "#{app_const}.routes.draw do"
  end
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
