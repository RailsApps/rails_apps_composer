# Application template recipe for the rails_apps_composer. Change the recipe here:
# https://github.com/RailsApps/rails_apps_composer/blob/master/recipes/rails_devise_pundit.rb

if prefer :apps4, 'rails-devise-pundit'
  prefs[:authentication] = 'devise'
  prefs[:authorization] = 'pundit'
  prefs[:better_errors] = true
  prefs[:git] = true
  prefs[:local_env_file] = false
  prefs[:pry] = false
  prefs[:pages] = 'about+users'
  prefs[:locale] = 'none'
  prefs[:rubocop] = false
  prefs[:rvmrc] = true
end

__END__

name: rails_devise_pundit
description: "rails-devise-pundit starter application"
author: RailsApps

requires: [core]
run_after: [git]
category: apps
