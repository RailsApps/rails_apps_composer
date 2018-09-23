# Application template recipe for the rails_apps_composer. Change the recipe here:
# https://github.com/RailsApps/rails_apps_composer/blob/master/recipes/rails_signup_thankyou.rb

if prefer :apps4, 'rails-signup-thankyou'
  prefs[:authentication] = 'devise'
  prefs[:authorization] = 'roles'
  prefs[:dashboard] = 'none'
  prefs[:ban_spiders] = false
  prefs[:better_errors] = true
  prefs[:database] = 'sqlite'
  prefs[:deployment] = 'none'
  prefs[:devise_modules] = false
  prefs[:dev_webserver] = 'puma'
  prefs[:email] = 'none'
  prefs[:frontend] = 'bootstrap3'
  prefs[:layouts] = 'none'
  prefs[:pages] = 'none'
  prefs[:github] = false
  prefs[:git] = true
  prefs[:local_env_file] = false
  prefs[:prod_webserver] = 'same'
  prefs[:pry] = false
  prefs[:pages] = 'about+users'
  prefs[:templates] = 'erb'
  prefs[:tests] = 'none'
  prefs[:locale] = 'none'
  prefs[:analytics] = 'none'
  prefs[:rubocop] = false
  prefs[:disable_turbolinks] = true
  prefs[:rvmrc] = true
  prefs[:form_builder] = false
  prefs[:jquery] = 'gem'

  stage_three do
    say_wizard "recipe stage three"
    repo = 'https://raw.github.com/RailsApps/rails-signup-thankyou/master/'

    # >-------------------------------[ Models ]--------------------------------<

    copy_from_repo 'app/models/user.rb', :repo => repo

    # >-------------------------------[ Controllers ]--------------------------------<

    copy_from_repo 'app/controllers/application_controller.rb', :repo => repo
    copy_from_repo 'app/controllers/visitors_controller.rb', :repo => repo
    copy_from_repo 'app/controllers/products_controller.rb', :repo => repo
    copy_from_repo 'app/controllers/thank_you_controller.rb', :repo => repo

    # >-------------------------------[ Views ]--------------------------------<

    copy_from_repo 'app/views/visitors/index.html.erb', :repo => repo
    copy_from_repo 'app/views/products/product.pdf', :repo => repo
    copy_from_repo 'app/views/thank_you/index.html.erb', :repo => repo

    # >-------------------------------[ Routes ]--------------------------------<

    copy_from_repo 'config/routes.rb', :repo => repo

    # >-------------------------------[ Tests ]--------------------------------<

    copy_from_repo 'spec/features/users/product_acquisition_spec.rb', :repo => repo
    copy_from_repo 'spec/controllers/products_controller_spec.rb', :repo => repo

  end
end

__END__

name: rails_signup_thankyou
description: "rails-signup-thankyou starter application"
author: RailsApps

requires: [core]
run_after: [git]
category: apps
