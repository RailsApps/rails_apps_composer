# Application template recipe for the rails_apps_composer. Change the recipe here:
# https://github.com/RailsApps/rails_apps_composer/blob/master/recipes/rails_mailinglist_activejob.rb

if prefer :apps4, 'rails-mailinglist-activejob'
  prefs[:authentication] = false
  prefs[:authorization] = false
  prefs[:dashboard] = 'none'
  prefs[:better_errors] = true
  prefs[:form_builder] = 'simple_form'
  prefs[:git] = true
  prefs[:local_env_file] = false
  prefs[:pry] = false
  prefs[:secrets] = ['mailchimp_list_id', 'mailchimp_api_key']
  prefs[:pages] = 'about'
  prefs[:locale] = 'none'
  prefs[:rubocop] = false
  prefs[:rvmrc] = true

  # gems
  add_gem 'gibbon'
  add_gem 'high_voltage'
  add_gem 'sucker_punch'

  stage_two do
    say_wizard "recipe stage two"
    generate 'model Visitor email:string'
  end

  stage_three do
    say_wizard "recipe stage three"
    repo = 'https://raw.github.com/RailsApps/rails-mailinglist-activejob/master/'

    # >-------------------------------[ Config ]---------------------------------<

    copy_from_repo 'config/initializers/active_job.rb', :repo => repo

    # >-------------------------------[ Models ]--------------------------------<

    copy_from_repo 'app/models/visitor.rb', :repo => repo

    # >-------------------------------[ Controllers ]--------------------------<

    copy_from_repo 'app/controllers/visitors_controller.rb', :repo => repo

    # >-------------------------------[ Jobs ]---------------------------------<

    copy_from_repo 'app/jobs/mailing_list_signup_job.rb', :repo => repo

    # >-------------------------------[ Views ]--------------------------------<

    remove_file 'app/views/visitors/index.html.erb'
    copy_from_repo 'app/views/visitors/new.html.erb', :repo => repo

    # >-------------------------------[ Routes ]-------------------------------<

    gsub_file 'config/routes.rb', /  root to: 'visitors#index'\n/, ''
    inject_into_file 'config/routes.rb', "  root to: 'visitors#new'\n", :after => "routes.draw do\n"
    route = '  resources :visitors, only: [:new, :create]'
    inject_into_file 'config/routes.rb', route + "\n", :after => "routes.draw do\n"

    # >-------------------------------[ Tests ]--------------------------------<

    ### tests not implemented

  end
end

__END__

name: rails_mailinglist_activejob
description: "rails_mailinglist_activejob starter application"
author: RailsApps

requires: [core]
run_after: [git]
category: apps
