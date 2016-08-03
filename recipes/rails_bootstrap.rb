# Application template recipe for the rails_apps_composer. Change the recipe here:
# https://github.com/RailsApps/rails_apps_composer/blob/master/recipes/rails_bootstrap.rb

if prefer :apps4, 'rails-bootstrap'
  prefs[:authentication] = false
  prefs[:authorization] = false
  prefs[:dashboard] = 'none'
  prefs[:better_errors] = true
  prefs[:devise_modules] = false
  prefs[:email] = 'none'
  prefs[:frontend] = 'bootstrap3'
  prefs[:git] = true
  prefs[:local_env_file] = false
  prefs[:pry] = false
  prefs[:pages] = 'about'
  prefs[:locale] = 'none'
  prefs[:rubocop] = false
end

__END__

name: rails_bootstrap
description: "rails-bootstrap starter application"
author: RailsApps

requires: [core]
run_after: [git]
category: apps
