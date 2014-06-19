# Application template recipe for the rails_apps_composer. Change the recipe here:
# https://github.com/RailsApps/rails_apps_composer/blob/master/recipes/views.rb

after_bundler do
  say_wizard "recipe running after 'bundle install'"
  ### DEVISE ###
  if (prefer :authentication, 'devise') and (not prefer :apps4, 'rails-devise')
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
