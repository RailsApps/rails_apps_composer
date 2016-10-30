# Application template recipe for the rails_apps_composer. Change the recipe here:
# https://github.com/RailsApps/rails_apps_composer/blob/master/recipes/rails_foundation.rb

if prefer :apps4, 'rails-foundation'
  prefs[:authentication] = false
  prefs[:authorization] = false
  prefs[:dashboard] = 'none'
  prefs[:better_errors] = true
  prefs[:devise_modules] = false
  prefs[:email] = 'none'
  prefs[:frontend] = 'foundation5'
  prefs[:git] = true
  prefs[:local_env_file] = false
  prefs[:pry] = false
  prefs[:pages] = 'about'
  prefs[:locale] = 'none'
  prefs[:rubocop] = false
  prefs[:rvmrc] = true
end

__END__

name: rails_foundation
description: "rails-foundation starter application"
author: RailsApps

requires: [core]
run_after: [git]
category: apps
