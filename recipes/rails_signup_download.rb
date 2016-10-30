# Application template recipe for the rails_apps_composer. Change the recipe here:
# https://github.com/RailsApps/rails_apps_composer/blob/master/recipes/rails_signup_download.rb

if prefer :apps4, 'rails-signup-download'
  prefs[:authentication] = 'devise'
  prefs[:authorization] = 'roles'
  prefs[:better_errors] = true
  prefs[:devise_modules] = false
  prefs[:form_builder] = false
  prefs[:git] = true
  prefs[:local_env_file] = false
  prefs[:pry] = false
  prefs[:secrets] = ['mailchimp_list_id', 'mailchimp_api_key']
  prefs[:pages] = 'about+users'
  prefs[:locale] = 'none'
  prefs[:rubocop] = false
  prefs[:rvmrc] = true

  # gems
  add_gem 'gibbon'
  add_gem 'sucker_punch'

  stage_three do
    say_wizard "recipe stage three"
    repo = 'https://raw.github.com/RailsApps/rails-signup-download/master/'

    # >-------------------------------[ Config ]---------------------------------<

    copy_from_repo 'config/initializers/active_job.rb', :repo => repo

    # >-------------------------------[ Models ]--------------------------------<

    copy_from_repo 'app/models/user.rb', :repo => repo

    # >-------------------------------[ Controllers ]--------------------------------<

    copy_from_repo 'app/controllers/visitors_controller.rb', :repo => repo
    copy_from_repo 'app/controllers/products_controller.rb', :repo => repo

    # >-------------------------------[ Jobs ]---------------------------------<

    copy_from_repo 'app/jobs/mailing_list_signup_job.rb', :repo => repo

    # >-------------------------------[ Views ]--------------------------------<

    copy_from_repo 'app/views/visitors/index.html.erb', :repo => repo
    copy_from_repo 'app/views/products/product.pdf', :repo => repo

    # >-------------------------------[ Routes ]--------------------------------<

    copy_from_repo 'config/routes.rb', :repo => repo

    # >-------------------------------[ Tests ]--------------------------------<

    copy_from_repo 'spec/features/users/product_acquisition_spec.rb', :repo => repo
    copy_from_repo 'spec/controllers/products_controller_spec.rb', :repo => repo

  end
end

__END__

name: rails_signup_download
description: "rails-signup-download starter application"
author: RailsApps

requires: [core]
run_after: [git]
category: apps
