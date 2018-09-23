# Application template recipe for the rails_apps_composer. Change the recipe here:
# https://github.com/RailsApps/rails_apps_composer/blob/master/recipes/core.rb

## Git
say_wizard "selected all core recipes"

__END__

name: core
description: "Select all core recipes."
author: RailsApps

requires: [git, railsapps,
  learn_rails,
  rails_bootstrap,
  rails_foundation,
  rails_omniauth,
  rails_devise,
  rails_devise_roles,
  rails_devise_pundit,
  rails_shortcut_app,
  rails_signup_download,
  rails_signup_thankyou,
  rails_mailinglist_activejob,
  rails_stripe_checkout,
  rails_stripe_coupons,
  rails_stripe_membership_saas,
  setup, locale, readme, gems,
  tests,
  email,
  devise, omniauth, roles,
  frontend, pages,
  init, analytics, deployment, extras]
category: collections
