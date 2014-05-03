# Application template recipe for the rails_apps_composer. Change the recipe here:
# https://github.com/RailsApps/rails_apps_composer/blob/master/recipes/apps4.rb

### LEARN-RAILS ####

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
  add_gem 'rails_12factor', :group => :production

  # >-------------------------------[ after_everything ]--------------------------------<

  after_everything do
    say_wizard "recipe running after 'bundle install'"
    repo = 'https://raw.github.com/RailsApps/learn-rails/master/'

    # >-------------------------------[ Models ]--------------------------------<

    copy_from_repo 'app/models/contact.rb', :repo => repo
    copy_from_repo 'app/models/visitor.rb', :repo => repo

    # >-------------------------------[ Init ]--------------------------------<
    copy_from_repo 'config/secrets.yml', :repo => repo

    # >-------------------------------[ Controllers ]--------------------------------<

    copy_from_repo 'app/controllers/contacts_controller.rb', :repo => repo
    copy_from_repo 'app/controllers/visitors_controller.rb', :repo => repo

    # >-------------------------------[ Mailers ]--------------------------------<

    generate 'mailer UserMailer'
    copy_from_repo 'app/mailers/user_mailer.rb', :repo => repo

    # >-------------------------------[ Views ]--------------------------------<

    copy_from_repo 'app/views/contacts/new.html.erb', :repo => repo
    copy_from_repo 'app/views/pages/about.html.erb', :repo => repo
    copy_from_repo 'app/views/user_mailer/contact_email.html.erb', :repo => repo
    copy_from_repo 'app/views/user_mailer/contact_email.text.erb', :repo => repo
    copy_from_repo 'app/views/visitors/new.html.erb', :repo => repo
    # create navigation links using the rails_layout gem
    generate 'layout:navigation -f'

    # >-------------------------------[ Routes ]--------------------------------<

    copy_from_repo 'config/routes.rb', :repo => repo

    # >-------------------------------[ Assets ]--------------------------------<

    copy_from_repo 'app/assets/javascripts/segmentio.js', :repo => repo

    ### GIT ###
    git :add => '-A' if prefer :git, true
    git :commit => '-qm "rails_apps_composer: learn-rails app"' if prefer :git, true
  end # after_bundler
end # learn-rails

### RAILS-BOOTSTRAP or RAILS-FOUNDATION ####
if (prefer :apps4, 'rails-bootstrap') || (prefer :apps4, 'rails-foundation')
  add_gem 'high_voltage'
  after_bundler do
    generate 'pages:home -f'
    generate 'pages:about -f'
    generate 'layout:navigation -f'
  end
end

### RAILS-DEVISE ####
if prefer :apps4, 'rails-devise'
  after_bundler do
    generate 'pages:users -f'
  end
end

### RAILS-DEVISE-PUNDIT ####
if prefer :apps4, 'rails-devise-pundit'
  after_bundler do
    generate 'pages:authorized -f'
  end
end

### RAILS-OMNIAUTH ####

if prefer :apps4, 'rails-omniauth'

  # >-------------------------------[ after_bundler ]--------------------------------<

  after_bundler do
    say_wizard "recipe running after 'bundle install'"
    repo = 'https://raw.github.com/RailsApps/rails-omniauth/master/'

    # >-------------------------------[ Models ]--------------------------------<

    copy_from_repo 'app/models/user.rb', :repo => repo

    # >-------------------------------[ Controllers ]--------------------------------<

    copy_from_repo 'app/controllers/home_controller.rb', :repo => repo
    copy_from_repo 'app/controllers/sessions_controller.rb', :repo => repo
    gsub_file 'app/controllers/sessions_controller.rb', /twitter/, prefs[:omniauth_provider]
    copy_from_repo 'app/controllers/users_controller.rb', :repo => repo

    # >-------------------------------[ Views ]--------------------------------<

    copy_from_repo 'app/views/home/index.html.erb', :repo => repo
    copy_from_repo 'app/views/users/edit.html.erb', :repo => repo
    copy_from_repo 'app/views/users/index.html.erb', :repo => repo
    copy_from_repo 'app/views/users/show.html.erb', :repo => repo

    # >-------------------------------[ Routes ]--------------------------------<

    copy_from_repo 'config/routes.rb', :repo => repo
    ### CORRECT APPLICATION NAME ###
    gsub_file 'config/routes.rb', /^.*.routes.draw do/, "#{app_const}.routes.draw do"

    ### GIT ###
    git :add => '-A' if prefer :git, true
    git :commit => '-qm "rails_apps_composer: rails-omniauth"' if prefer :git, true

  end

end # rails-omniauth

after_everything do
  generate 'clean:gemfile'
  generate 'clean:routes'
  git :add => '-A' if prefer :git, true
  git :commit => "-qm \"rails_apps_composer: #{prefs[:apps4]}\"" if prefer :git, true
end

__END__

name: apps4
description: "Install RailsApps starter applications for Rails 4.0."
author: RailsApps

requires: [core]
run_after: [setup, gems]
category: apps
