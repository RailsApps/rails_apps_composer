# Application template recipe for the rails_apps_composer. Change the recipe here:
# https://github.com/RailsApps/rails_apps_composer/blob/master/recipes/rails_stripe_membership_saas.rb

if prefer :apps4, 'rails-stripe-membership-saas'
  prefs[:frontend] = 'bootstrap3'
  prefs[:authentication] = 'devise'
  prefs[:authorization] = 'roles'
  prefs[:better_errors] = true
  prefs[:devise_modules] = false
  prefs[:form_builder] = false
  prefs[:git] = true
  prefs[:local_env_file] = false
  prefs[:pry] = false
  prefs[:disable_turbolinks] = true
  prefs[:secrets] = ['stripe_publishable_key',
    'stripe_api_key',
    'mailchimp_list_id',
    'mailchimp_api_key']
  prefs[:pages] = 'about+users'
  prefs[:locale] = 'none'
  prefs[:rubocop] = false
  prefs[:rvmrc] = true

  # gems
  add_gem 'gibbon'
  add_gem 'payola-payments'
  add_gem 'sucker_punch'

  stage_three do
    say_wizard "recipe stage three"
    repo = 'https://raw.github.com/RailsApps/rails-stripe-membership-saas/master/'

    # >-------------------------------[ Migrations ]---------------------------------<

    generate 'payola:install'
    generate 'model Plan name stripe_id interval amount:integer --no-test-framework'
    generate 'migration AddPlanRefToUsers plan:references'
    generate 'migration RemoveNameFromUsers name'
    run 'bundle exec rake db:migrate'

    # >-------------------------------[ Config ]---------------------------------<

    copy_from_repo 'config/initializers/active_job.rb', :repo => repo
    copy_from_repo 'config/initializers/payola.rb', :repo => repo
    copy_from_repo 'db/seeds.rb', :repo => repo

    # >-------------------------------[ Assets ]--------------------------------<

    copy_from_repo 'app/assets/stylesheets/pricing.css.scss', :repo => repo

    # >-------------------------------[ Controllers ]--------------------------------<

    copy_from_repo 'app/controllers/application_controller.rb', :repo => repo
    copy_from_repo 'app/controllers/content_controller.rb', :repo => repo
    copy_from_repo 'app/controllers/visitors_controller.rb', :repo => repo
    copy_from_repo 'app/controllers/products_controller.rb', :repo => repo
    copy_from_repo 'app/controllers/registrations_controller.rb', :repo => repo

    # >-------------------------------[ Jobs ]---------------------------------<

    copy_from_repo 'app/jobs/mailing_list_signup_job.rb', :repo => repo

    # >-------------------------------[ Mailers ]--------------------------------<

    copy_from_repo 'app/mailers/application_mailer.rb', :repo => repo
    copy_from_repo 'app/mailers/user_mailer.rb', :repo => repo

    # >-------------------------------[ Models ]--------------------------------<

    copy_from_repo 'app/models/plan.rb', :repo => repo
    copy_from_repo 'app/models/user.rb', :repo => repo

    # >-------------------------------[ Services ]---------------------------------<

    copy_from_repo 'app/services/create_plan_service.rb', :repo => repo

    # >-------------------------------[ Views ]--------------------------------<

    copy_from_repo 'app/views/content/gold.html.erb', :repo => repo
    copy_from_repo 'app/views/content/platinum.html.erb', :repo => repo
    copy_from_repo 'app/views/content/silver.html.erb', :repo => repo
    copy_from_repo 'app/views/devise/registrations/edit.html.erb', :repo => repo
    copy_from_repo 'app/views/devise/registrations/new.html.erb', :repo => repo
    copy_from_repo 'app/views/layouts/_navigation_links.html.erb', :repo => repo
    copy_from_repo 'app/views/layouts/application.html.erb', :repo => repo
    copy_from_repo 'app/views/layouts/mailer.html.erb', :repo => repo
    copy_from_repo 'app/views/layouts/mailer.text.erb', :repo => repo
    copy_from_repo 'app/views/user_mailer/expire_email.html.erb', :repo => repo
    copy_from_repo 'app/views/user_mailer/expire_email.text.erb', :repo => repo
    copy_from_repo 'app/views/visitors/index.html.erb', :repo => repo
    copy_from_repo 'app/views/products/product.pdf', :repo => repo

    # >-------------------------------[ Routes ]--------------------------------<

    copy_from_repo 'config/routes.rb', :repo => repo

    # >-------------------------------[ Tests ]--------------------------------<

    ### tests not implemented

  end
end

__END__

name: rails_stripe_membership_saas
description: "rails-stripe-membership-saas starter application"
author: RailsApps

requires: [core]
run_after: [git]
category: apps
