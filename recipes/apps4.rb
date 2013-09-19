# Application template recipe for the rails_apps_composer. Change the recipe here:
# https://github.com/RailsApps/rails_apps_composer/blob/master/recipes/apps4.rb

if prefer :apps4, 'learn-rails'

  # >-------------------------------[ Gems ]--------------------------------<

  add_gem 'activerecord-tableless'
  add_gem 'high_voltage'
  add_gem 'gibbon'
  add_gem 'google_drive'
  gsub_file 'Gemfile', /gem 'sqlite3'\n/, ''
  add_gem 'sqlite3', :group => :development
  add_gem 'pg', :group => :production
  add_gem 'thin', :group => :production
  add_gem 'rails_on_heroku', :group => :production

  # >-------------------------------[ after_everything ]--------------------------------<

  after_everything do
    say_wizard "recipe running after 'bundle install'"
    repo = 'https://raw.github.com/RailsApps/learn-rails/master/'

    # >-------------------------------[ Clean up starter app ]--------------------------------<

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

    # >-------------------------------[ Models ]--------------------------------<

    copy_from_repo 'app/models/contact.rb', :repo => repo
    copy_from_repo 'app/models/visitor.rb', :repo => repo

    # >-------------------------------[ Init ]--------------------------------<
    copy_from_repo 'config/application.yml', :repo => repo
    remove_file 'config/application.example.yml'
    copy_file destination_root + '/config/application.yml', destination_root + '/config/application.example.yml'

    # >-------------------------------[ Controllers ]--------------------------------<

    copy_from_repo 'app/controllers/contacts_controller.rb', :repo => repo
    copy_from_repo 'app/controllers/visitors_controller.rb', :repo => repo

    # >-------------------------------[ Mailers ]--------------------------------<

    generate 'mailer UserMailer'
    copy_from_repo 'app/mailers/user_mailer.rb', :repo => repo

    # >-------------------------------[ Layouts ]--------------------------------<

    if prefer :frontend, 'bootstrap'
      generate 'layout:bootstrap2'
    end

    # >-------------------------------[ Views ]--------------------------------<

    copy_from_repo 'app/views/contacts/new.html.erb', :repo => repo
    copy_from_repo 'app/views/pages/about.html.erb', :repo => repo
    copy_from_repo 'app/views/user_mailer/contact_email.html.erb', :repo => repo
    copy_from_repo 'app/views/user_mailer/contact_email.text.erb', :repo => repo
    copy_from_repo 'app/views/visitors/new.html.erb', :repo => repo

    # >-------------------------------[ Routes ]--------------------------------<

    copy_from_repo 'config/routes.rb', :repo => repo
    ### CORRECT APPLICATION NAME ###
    gsub_file 'config/routes.rb', /^.*.routes.draw do/, "#{app_const}.routes.draw do"

    # >-------------------------------[ Assets ]--------------------------------<

    copy_from_repo 'app/assets/javascripts/application.js', :repo => repo
    copy_from_repo 'app/assets/javascripts/segmentio.js', :repo => repo
    copy_from_repo 'app/assets/stylesheets/application.css.scss', :repo => repo
    copy_from_repo 'app/assets/stylesheets/bootstrap_and_overrides.css.scss', :repo => repo

    ### GIT ###
    git :add => '-A' if prefer :git, true
    git :commit => '-qm "rails_apps_composer: learn-rails app"' if prefer :git, true
  end # after_bundler
end # learn-rails

if prefer :apps4, 'rails-bootstrap'

  # >-------------------------------[ Gems ]--------------------------------<

  add_gem 'high_voltage'

  # >-------------------------------[ after_everything ]--------------------------------<

  after_everything do
    say_wizard "recipe running after 'bundle install'"
    repo = 'https://raw.github.com/RailsApps/rails-bootstrap/master/'

    # >-------------------------------[ Clean up starter app ]--------------------------------<

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

    # >-------------------------------[ Models ]--------------------------------<

    copy_from_repo 'app/models/visitor.rb', :repo => repo

    # >-------------------------------[ Init ]--------------------------------<
    copy_from_repo 'config/application.yml', :repo => repo
    remove_file 'config/application.example.yml'
    copy_file destination_root + '/config/application.yml', destination_root + '/config/application.example.yml'

    # >-------------------------------[ Controllers ]--------------------------------<

    copy_from_repo 'app/controllers/visitors_controller.rb', :repo => repo

    # >-------------------------------[ Layouts ]--------------------------------<

    if prefer :frontend, 'bootstrap'
      generate 'layout:bootstrap2'
    end

    # >-------------------------------[ Views ]--------------------------------<

    copy_from_repo 'app/views/pages/about.html.erb', :repo => repo
    copy_from_repo 'app/views/visitors/new.html.erb', :repo => repo

    # >-------------------------------[ Routes ]--------------------------------<

    copy_from_repo 'config/routes.rb', :repo => repo
    ### CORRECT APPLICATION NAME ###
    gsub_file 'config/routes.rb', /^.*.routes.draw do/, "#{app_const}.routes.draw do"

    # >-------------------------------[ Assets ]--------------------------------<

    copy_from_repo 'app/assets/javascripts/application.js', :repo => repo
    copy_from_repo 'app/assets/stylesheets/application.css.scss', :repo => repo
    copy_from_repo 'app/assets/stylesheets/bootstrap_and_overrides.css.scss', :repo => repo

    ### GIT ###
    git :add => '-A' if prefer :git, true
    git :commit => '-qm "rails_apps_composer: rails-bootstrap app"' if prefer :git, true
  end # after_bundler
end # rails-bootstrap

__END__

name: apps4
description: "Install RailsApps starter applications for Rails 4.0."
author: RailsApps

requires: [core]
run_after: [setup, gems]
category: apps
