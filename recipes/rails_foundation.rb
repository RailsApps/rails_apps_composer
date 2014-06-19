# Application template recipe for the rails_apps_composer. Change the recipe here:
# https://github.com/RailsApps/rails_apps_composer/blob/master/recipes/rails_foundation.rb

if prefer :apps4, 'rails-foundation'
  prefs[:authentication] = false
  prefs[:authorization] = false
  prefs[:better_errors] = true
  prefs[:database] = 'default'
  prefs[:deployment] = 'none'
  prefs[:devise_modules] = false
  prefs[:email] = 'none'
  prefs[:form_builder] = false
  prefs[:frontend] = 'foundation5'
  prefs[:git] = true
  prefs[:local_env_file] = false
  prefs[:pry] = false
  prefs[:quiet_assets] = true
  add_gem 'high_voltage'
  after_everything do
    generate 'pages:home -f'
    generate 'pages:about -f'
    generate 'layout:navigation -f'
  end
end

__END__

name: rails_foundation
description: "rails-foundation starter application"
author: RailsApps

requires: [core]
run_after: [git]
category: apps
