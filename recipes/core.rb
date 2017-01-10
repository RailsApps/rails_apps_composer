# Application template recipe for the rails_apps_composer. Change the recipe here:
# https://github.com/RailsApps/rails_apps_composer/blob/master/recipes/core.rb

## Git
say_wizard "selected all core recipes"

__END__

name: core
description: "Select all core recipes."
author: RailsApps

requires: [git, railsapps, rails_datarockets_api,
  setup, locale, readme, gems,
  tests,
  email,
  devise, omniauth, roles,
  frontend, pages,
  init, analytics, deployment, extras]
category: collections
