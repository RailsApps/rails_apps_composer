# Application template recipe for the rails_apps_composer. Change the recipe here:
# https://github.com/RailsApps/rails_apps_composer/blob/master/recipes/prelaunch.rb

if prefer :railsapps, 'rails-prelaunch-signup'
  
  after_everything do
    say_wizard "recipe running after 'bundle install'"
    repo = 'https://raw.github.com/RailsApps/rails-prelaunch-signup/master/'

    # >-------------------------------[ Clean up starter app ]--------------------------------<

    %w{
      public/index.html
      app/assets/images/rails.png
    }.each { |file| remove_file file }
    # remove commented lines and multiple blank lines from Gemfile
    # thanks to https://github.com/perfectline/template-bucket/blob/master/cleanup.rb
    gsub_file 'Gemfile', /#.*\n/, "\n"
    gsub_file 'Gemfile', /\n^\s*\n/, "\n"
    # remove commented lines and multiple blank lines from config/routes.rb
    gsub_file 'config/routes.rb', /  #.*\n/, "\n"
    gsub_file 'config/routes.rb', /\n^\s*\n/, "\n"
    # GIT
    git :add => '-A' if prefer :git, true
    git :commit => '-qm "rails_apps_composer: clean up starter app"' if prefer :git, true

    # >-------------------------------[ Create a git branch ]--------------------------------<
    if prefer :git, true
      if prefer :prelaunch_branch, 'master'
        unless prefer :main_branch, 'none'
          say_wizard "renaming git branch 'master' to '#{prefs[:main_branch]}' for starter app"
          git :branch => "-m master #{prefs[:main_branch]}"
          git :checkout => "-b master"
        else
          say_wizard "creating prelaunch app on git branch 'master'"
        end
      else
        say_wizard "creating new git branch '#{prefs[:prelaunch_branch]}' for prelaunch app"
        git :checkout => "-b #{prefs[:prelaunch_branch]}"
      end
    end

    # >-------------------------------[ Cucumber ]--------------------------------<
    say_wizard "copying Cucumber scenarios from the rails-prelaunch-signup examples"
    copy_from_repo 'features/admin/send_invitations.feature', :repo => repo    
    copy_from_repo 'features/admin/view_progress.feature', :repo => repo
    copy_from_repo 'features/visitors/request_invitation.feature', :repo => repo
    copy_from_repo 'features/users/sign_in.feature', :repo => repo
    copy_from_repo 'features/users/sign_up.feature', :repo => repo
    copy_from_repo 'features/users/user_show.feature', :repo => repo
    copy_from_repo 'features/step_definitions/admin_steps.rb', :repo => repo
    copy_from_repo 'features/step_definitions/user_steps.rb', :repo => repo    
    copy_from_repo 'features/step_definitions/visitor_steps.rb', :repo => repo
    copy_from_repo 'config/locales/devise.en.yml', :repo => repo

    # >-------------------------------[ Migrations ]--------------------------------<

    generate 'migration AddOptinToUsers opt_in:boolean'
    run 'bundle exec rake db:drop'
    run 'bundle exec rake db:migrate'
    run 'bundle exec rake db:test:prepare'
    run 'bundle exec rake db:seed'

    # >-------------------------------[ Models ]--------------------------------<

    copy_from_repo 'app/models/user.rb', :repo => repo

    # >-------------------------------[ Controllers ]--------------------------------<

    copy_from_repo 'app/controllers/confirmations_controller.rb', :repo => repo
    copy_from_repo 'app/controllers/home_controller.rb', :repo => repo
    copy_from_repo 'app/controllers/registrations_controller.rb', :repo => repo
    copy_from_repo 'app/controllers/users_controller.rb', :repo => repo

    # >-------------------------------[ Mailers ]--------------------------------<
    
    generate 'mailer UserMailer'
    copy_from_repo 'spec/mailers/user_mailer_spec.rb', :repo => repo
    copy_from_repo 'app/mailers/user_mailer.rb', :repo => repo

    # >-------------------------------[ Views ]--------------------------------<

    copy_from_repo 'app/views/devise/confirmations/show.html.erb', :repo => repo
    copy_from_repo 'app/views/devise/mailer/confirmation_instructions.html.erb', :repo => repo
    copy_from_repo 'app/views/devise/registrations/_thankyou.html.erb', :repo => repo
    copy_from_repo 'app/views/devise/registrations/new.html.erb', :repo => repo
    copy_from_repo 'app/views/devise/shared/_links.html.erb', :repo => repo
    copy_from_repo 'app/views/home/index.html.erb', :repo => repo
    copy_from_repo 'app/views/user_mailer/welcome_email.html.erb', :repo => repo
    copy_from_repo 'app/views/user_mailer/welcome_email.text.erb', :repo => repo
    copy_from_repo 'app/views/users/index.html.erb', :repo => repo
    copy_from_repo 'public/thankyou.html', :repo => repo

    # >-------------------------------[ Routes ]--------------------------------<
    
    copy_from_repo 'config/routes.rb', :repo => repo
    ### CORRECT APPLICATION NAME ###
    gsub_file 'config/routes.rb', /^.*.routes.draw do/, "#{app_const}.routes.draw do"
    
    # >-------------------------------[ Assets ]--------------------------------<
    
    copy_from_repo 'app/assets/javascripts/application.js', :repo => repo
    copy_from_repo 'app/assets/javascripts/users.js.coffee', :repo => repo
    copy_from_repo 'app/assets/stylesheets/application.css.scss', :repo => repo
    
    ### GIT ###
    git :add => '-A' if prefer :git, true
    git :commit => '-qm "rails_apps_composer: prelaunch app"' if prefer :git, true
  end # after_bundler
end # rails-prelaunch-signup

__END__

name: prelaunch
description: "Install a prelaunch-signup example application."
author: RailsApps

requires: [core]
run_after: [setup, gems, models, controllers, views, frontend, init]
category: apps
