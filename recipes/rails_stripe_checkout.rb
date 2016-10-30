# Application template recipe for the rails_apps_composer. Change the recipe here:
# https://github.com/RailsApps/rails_apps_composer/blob/master/recipes/rails_stripe_checkout.rb

if prefer :apps4, 'rails-stripe-checkout'
  prefs[:frontend] = 'bootstrap3'
  prefs[:authentication] = 'devise'
  prefs[:authorization] = 'roles'
  prefs[:better_errors] = true
  prefs[:devise_modules] = false
  prefs[:form_builder] = false
  prefs[:git] = true
  prefs[:local_env_file] = false
  prefs[:pry] = false
  prefs[:secrets] = ['product_price',
    'product_title',
    'stripe_publishable_key',
    'stripe_api_key',
    'mailchimp_list_id',
    'mailchimp_api_key']
  prefs[:pages] = 'about+users'
  prefs[:locale] = 'none'
  prefs[:rubocop] = false
  prefs[:rvmrc] = true

  # gems
  add_gem 'gibbon'
  add_gem 'stripe'
  add_gem 'sucker_punch'

  stage_three do
    say_wizard "recipe stage three"
    repo = 'https://raw.github.com/RailsApps/rails-stripe-checkout/master/'

    # >-------------------------------[ Config ]---------------------------------<

    copy_from_repo 'config/initializers/active_job.rb', :repo => repo
    copy_from_repo 'config/initializers/devise_permitted_parameters.rb', :repo => repo
    copy_from_repo 'config/initializers/stripe.rb', :repo => repo

    # >-------------------------------[ Assets ]--------------------------------<

    copy_from_repo 'app/assets/images/rubyonrails.png', :repo => repo

    # >-------------------------------[ Models ]--------------------------------<

    copy_from_repo 'app/models/user.rb', :repo => repo

    # >-------------------------------[ Controllers ]--------------------------------<

    copy_from_repo 'app/controllers/visitors_controller.rb', :repo => repo
    copy_from_repo 'app/controllers/products_controller.rb', :repo => repo
    copy_from_repo 'app/controllers/registrations_controller.rb', :repo => repo

    # >-------------------------------[ Jobs ]---------------------------------<

    copy_from_repo 'app/jobs/mailing_list_signup_job.rb', :repo => repo

    # >-------------------------------[ Views ]--------------------------------<

    copy_from_repo 'app/views/devise/registrations/new.html.erb', :repo => repo
    copy_from_repo 'app/views/visitors/_purchase.html.erb', :repo => repo
    copy_from_repo 'app/views/visitors/index.html.erb', :repo => repo
    copy_from_repo 'app/views/products/product.pdf', :repo => repo

    # >-------------------------------[ Routes ]--------------------------------<

    copy_from_repo 'config/routes.rb', :repo => repo

    # >-------------------------------[ Tests ]--------------------------------<

    ### tests not implemented

  end
end

__END__

name: rails_stripe_checkout
description: "rails-stripe-checkout starter application"
author: RailsApps

requires: [core]
run_after: [git]
category: apps
