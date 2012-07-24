# Application template recipe for the rails_apps_composer. Change the recipe here:
# https://github.com/RailsApps/rails_apps_composer/blob/master/recipes/prelaunch.rb

if recipes.include? 'signup_app'
  raise StandardError.new "Sorry. The prelaunch recipe is not implemented."
  
  after_bundler do
    say_wizard "recipe running after 'bundle install'"
    repo = 'https://raw.github.com/RailsApps/rails-prelaunch-signup/master/'

    # >-------------------------------[ Create a git branch ]--------------------------------<
    if recipes.include? 'git'
      if prelaunch_branch == 'master'
        unless main_branch == 'none'
          say_wizard "renaming git branch 'master' to '#{main_branch}' for starter app"
          git :branch => "-m master #{main_branch}"
          git :checkout => "-b master"
        else
          say_wizard "creating prelaunch app on git branch 'master'"
        end
      else
        say_wizard "creating new git branch '#{prelaunch_branch}' for prelaunch app"
        git :checkout => "-b #{prelaunch_branch}"
      end
    end

    # >-------------------------------[ Create an initializer file ]--------------------------------<
    copy_from_repo 'config/initializers/prelaunch-signup.rb', :repo => repo
    say_wizard "PRELAUNCH_SIGNUP NOT IMPLEMENTED"

    ### GIT ###
    git :add => '.' if recipes.include? 'git'
    git :commit => "-aqm 'rails_apps_composer: prelaunch app'" if recipes.include? 'git'
  end # after_bundler
end # signup_app

__END__

name: prelaunch
description: "Generates a Prelaunch Signup App"
author: RailsApps

run_after: [extras]
category: other
tags: [utilities, configuration]
