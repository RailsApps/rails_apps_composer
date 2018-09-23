# Application template recipe for the rails_apps_composer. Change the recipe here:
# https://github.com/RailsApps/rails_apps_composer/blob/master/recipes/rails_shortcut_app.rb

if prefer :apps4, 'rails-shortcut-app'
  prefs[:authentication] = 'devise'
  prefs[:authorization] = 'roles'
  prefs[:dashboard] = 'none'
  prefs[:ban_spiders] = false
  prefs[:better_errors] = true
  prefs[:database] = 'sqlite'
  prefs[:deployment] = 'none'
  prefs[:devise_modules] = false
  prefs[:dev_webserver] = 'puma'
  prefs[:email] = 'none'
  prefs[:frontend] = 'bootstrap3'
  prefs[:layouts] = 'none'
  prefs[:pages] = 'none'
  prefs[:github] = false
  prefs[:git] = true
  prefs[:local_env_file] = false
  prefs[:prod_webserver] = 'same'
  prefs[:pry] = false
  prefs[:pages] = 'about+users'
  prefs[:templates] = 'erb'
  prefs[:tests] = 'none'
  prefs[:locale] = 'none'
  prefs[:analytics] = 'none'
  prefs[:rubocop] = false
  prefs[:disable_turbolinks] = true
  prefs[:rvmrc] = true
  prefs[:form_builder] = false
  prefs[:jquery] = 'gem'
end

__END__

name: rails_shortcut_app
description: "rails-shortcut-app starter application"
author: RailsApps

requires: [core]
run_after: [git]
category: apps
