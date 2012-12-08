# Application template recipe for the rails_apps_composer. Change the recipe here:
# https://github.com/RailsApps/rails_apps_composer/blob/master/recipes/views.rb

after_bundler do
  say_wizard "recipe running after 'bundle install'"
  ### DEVISE ###
  if prefer :authentication, 'devise'
    copy_from_repo 'app/views/devise/shared/_links.html.erb'
    unless prefer :form_builder, 'simple_form'
      copy_from_repo 'app/views/devise/registrations/edit.html.erb'
      copy_from_repo 'app/views/devise/registrations/new.html.erb'
    else
      copy_from_repo 'app/views/devise/registrations/edit-simple_form.html.erb', :prefs => 'simple_form'
      copy_from_repo 'app/views/devise/registrations/new-simple_form.html.erb', :prefs => 'simple_form'
      copy_from_repo 'app/views/devise/sessions/new-simple_form.html.erb', :prefs => 'simple_form'
      copy_from_repo 'app/helpers/application_helper-simple_form.rb', :prefs => 'simple_form'
    end
  end
  ### HOME ###
  copy_from_repo 'app/views/home/index.html.erb' if prefer :starter_app, 'users_app'
  copy_from_repo 'app/views/home/index.html.erb' if prefer :starter_app, 'admin_app'
  copy_from_repo 'app/views/home/index-subdomains_app.html.erb', :prefs => 'subdomains_app'
  ### USERS ###
  if ['users_app','admin_app','subdomains_app'].include? prefs[:starter_app]
    ## INDEX
    if prefer :starter_app, 'admin_app'
      copy_from_repo 'app/views/users/index-admin_app.html.erb', :prefs => 'admin_app'
      unless prefer :form_builder, 'simple_form'
        copy_from_repo 'app/views/users/_user.html.erb'
      else
        copy_from_repo 'app/views/users/_user-simple_form.html.erb', :prefs => 'simple_form'
      end
    else
      copy_from_repo 'app/views/users/index.html.erb'
    end
    ## SHOW
    copy_from_repo 'app/views/users/show.html.erb'
    copy_from_repo 'app/views/users/show-subdomains_app.html.erb', :prefs => 'subdomains_app'
    ## EDIT
    copy_from_repo 'app/views/users/edit-omniauth.html.erb', :prefs => 'omniauth'
  end
  ### PROFILES ###
  copy_from_repo 'app/views/profiles/show-subdomains_app.html.erb', :prefs => 'subdomains_app'
  ### GIT ###
  git :add => '-A' if prefer :git, true
  git :commit => '-qm "rails_apps_composer: views"' if prefer :git, true
end # after_bundler

__END__

name: views
description: "Add views needed for starter apps."
author: RailsApps

requires: [setup, gems, models, controllers]
run_after: [setup, gems, models, controllers]
category: mvc