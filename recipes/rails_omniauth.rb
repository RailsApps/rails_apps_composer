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
  add_gem 'high_voltage'
  after_everything do
    generate 'pages:users -f'
    generate 'pages:about -f'
    generate 'layout:navigation -f'
    repo = 'https://raw.github.com/RailsApps/rails-omniauth/master/'
  end
end

__END__

name: rails_omniauth
description: "rails-omniauth starter application"
author: RailsApps

requires: [core]
run_after: [git]
category: apps
