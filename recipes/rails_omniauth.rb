# Application template recipe for the rails_apps_composer. Change the recipe here:
# https://github.com/RailsApps/rails_apps_composer/blob/master/recipes/rails_omniauth.rb

if prefer :apps4, 'rails-omniauth'

  prefs[:authentication] = 'omniauth'
  prefs[:authorization] = 'none'
  prefs[:better_errors] = true
  prefs[:deployment] = 'none'
  prefs[:email] = 'none'
  prefs[:git] = true
  prefs[:local_env_file] = false
  prefs[:pry] = false
  prefs[:quiet_assets] = true
  prefs[:starter_app] = false

  after_everything do

    repo = 'https://raw.github.com/RailsApps/rails-omniauth/master/'

    # >-------------------------------[ Models ]--------------------------------<

    copy_from_repo 'app/models/user.rb', :repo => repo

    # >-------------------------------[ Controllers ]--------------------------------<

    copy_from_repo 'app/controllers/home_controller.rb', :repo => repo
    copy_from_repo 'app/controllers/sessions_controller.rb', :repo => repo
    gsub_file 'app/controllers/sessions_controller.rb', /twitter/, prefs[:omniauth_provider]
    copy_from_repo 'app/controllers/users_controller.rb', :repo => repo

    # >-------------------------------[ Views ]--------------------------------<

    copy_from_repo 'app/views/home/index.html.erb', :repo => repo
    copy_from_repo 'app/views/users/edit.html.erb', :repo => repo
    copy_from_repo 'app/views/users/index.html.erb', :repo => repo
    copy_from_repo 'app/views/users/show.html.erb', :repo => repo

    # >-------------------------------[ Routes ]--------------------------------<

    copy_from_repo 'config/routes.rb', :repo => repo
    # correct application name
    gsub_file 'config/routes.rb', /^.*.routes.draw do/, "#{app_const}.routes.draw do"

  end
end

__END__

name: rails_omniauth
description: "rails-omniauth starter application"
author: RailsApps

requires: [core]
run_after: [git]
category: apps
