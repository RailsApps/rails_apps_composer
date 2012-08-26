# Application template recipe for the rails_apps_composer. Change the recipe here:
# https://github.com/RailsApps/rails_apps_composer/blob/master/recipes/views.rb

after_bundler do
  say_wizard "recipe running after 'bundle install'"
  ### DEVISE ###
  copy_from_repo 'app/views/devise/shared/_links.html.erb' if prefer :authentication, 'devise'
  copy_from_repo 'app/views/devise/registrations/edit.html.erb' if prefer :authentication, 'devise'
  copy_from_repo 'app/views/devise/registrations/new.html.erb' if prefer :authentication, 'devise'
  ### HOME ###
  copy_from_repo 'app/views/home/index.html.erb' if prefer :starter_app, 'users_app'
  copy_from_repo 'app/views/home/index.html.erb' if prefer :starter_app, 'admin_app'
  copy_from_repo 'app/views/home/index-subdomains_app.html.erb', :prefs => 'subdomains_app'
  ### USERS ###
  if ['users_app','admin_app','subdomains_app'].include? prefs[:starter_app]
    ## INDEX
    copy_from_repo 'app/views/users/index.html.erb'
    ## SHOW
    copy_from_repo 'app/views/users/show.html.erb'
    copy_from_repo 'app/views/users/show-subdomains_app.html.erb', :prefs => 'subdomains_app'
    ## EDIT
    copy_from_repo 'app/views/users/edit-omniauth.html.erb', :prefs => 'omniauth'
  end
  ### PROFILES ###
  copy_from_repo 'app/views/profiles/show-subdomains_app.html.erb', :prefs => 'subdomains_app'
  ### GIT ###
  git :add => '.' if prefer :git, true
  git :commit => "-aqm 'rails_apps_composer: views'" if prefer :git, true
end # after_bundler

__END__

name: views
description: "Add views needed for starter apps."
author: RailsApps

requires: [setup, gems, models, controllers]
run_after: [setup, gems, models, controllers]
category: mvc