# Application template recipe for the rails_apps_composer. Change the recipe here:
# https://github.com/RailsApps/rails_apps_composer/blob/master/recipes/all.rb

## Git
say_wizard "selected all recipes"

__END__

name: all
description: "Select all available recipes."
author: RailsApps

requires: [git, railsapps, setup, readme, gems, testing, auth, email, models, controllers, views, routes, frontend, init, extras]
category: all