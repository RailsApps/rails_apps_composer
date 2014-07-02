# Application template recipe for the rails_apps_composer. Change the recipe here:
# https://github.com/RailsApps/rails_apps_composer/blob/master/recipes/rails_omniauth_mongoid.rb

if prefer :apps4, 'rails-omniauth-mongoid'
  prefs[:authentication] = 'omniauth'
  prefs[:authorization] = 'none'
  prefs[:better_errors] = true
  prefs[:deployment] = 'none'
  prefs[:email] = 'none'
  prefs[:git] = true
  prefs[:local_env_file] = false
  prefs[:pry] = false
  prefs[:quiet_assets] = true
  prefs[:pages] = 'about+users'
  prefs[:locale] = 'none'

  # gems
  add_gem 'mongoid'

  stage_two do
    say_wizard "recipe stage two"
    ## run generators
    ## or anything that must happen before stage_three

  end

  stage_three do
    say_wizard "recipe stage three"
    repo = 'https://raw.github.com/RailsApps/rails_omniauth_mongoid/master/'

    ## copy files from the repo
    ## add or replace files that are different from the rails-omniauth application

    # >-------------------------------[ Config ]---------------------------------<


    # >-------------------------------[ Models ]--------------------------------<


    # >-------------------------------[ Controllers ]--------------------------<


    # >-------------------------------[ Jobs ]---------------------------------<


    # >-------------------------------[ Views ]--------------------------------<


    # >-------------------------------[ Routes ]-------------------------------<


    # >-------------------------------[ Tests ]--------------------------------<

  end
end

__END__

name: rails_omniauth_mongoid
description: "rails-omniauth-mongoid starter application"
author: Ricardo Bruzos

requires: [core]
run_after: [git]
category: apps
