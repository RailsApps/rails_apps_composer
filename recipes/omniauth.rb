# Application template recipe for the rails_apps_composer. Change the recipe here:
# https://github.com/RailsApps/rails_apps_composer/blob/master/recipes/omniauth.rb

stage_two do
  say_wizard "recipe stage two"
  if prefer :authentication, 'omniauth'
    repo = 'https://raw.github.com/RailsApps/rails-omniauth/master/'
    copy_from_repo 'config/initializers/omniauth.rb', :repo => repo
    gsub_file 'config/initializers/omniauth.rb', /twitter/, prefs[:omniauth_provider] unless prefer :omniauth_provider, 'twitter'
    generate 'model User name:string provider:string uid:string'
    run 'bundle exec rake db:migrate'
    copy_from_repo 'app/models/user.rb', :repo => 'https://raw.github.com/RailsApps/rails-omniauth/master/'
    copy_from_repo 'app/controllers/application_controller.rb', :repo => repo
    filename = 'app/controllers/sessions_controller.rb'
    copy_from_repo filename, :repo => repo
    gsub_file filename, /twitter/, prefs[:omniauth_provider] unless prefer :omniauth_provider, 'twitter'
    routes = <<-TEXT
  get '/auth/:provider/callback' => 'sessions#create'
  get '/signin' => 'sessions#new', :as => :signin
  get '/signout' => 'sessions#destroy', :as => :signout
  get '/auth/failure' => 'sessions#failure'
TEXT
    inject_into_file 'config/routes.rb', routes + "\n", :after => "routes.draw do\n"
  end
  ### GIT ###
  git :add => '-A' if prefer :git, true
  git :commit => '-qm "rails_apps_composer: omniauth"' if prefer :git, true
end

__END__

name: omniauth
description: "Add OmniAuth for authentication"
author: RailsApps

requires: [setup, gems]
run_after: [setup, gems]
category: mvc
