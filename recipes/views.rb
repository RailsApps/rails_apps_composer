# Application template recipe for the rails_apps_composer. Change the recipe here:
# https://github.com/RailsApps/rails_apps_composer/blob/master/recipes/views.rb

after_bundler do
  say_wizard "recipe running after 'bundle install'"
  ### DEVISE ###
  copy_from_repo 'app/views/devise/shared/_links.html.erb' if recipes.include? 'devise'
  copy_from_repo 'app/views/devise/registrations/edit.html.erb' if recipes.include? 'devise'
  copy_from_repo 'app/views/devise/registrations/new.html.erb' if recipes.include? 'devise'
  ### HOME ###
  copy_from_repo 'app/views/home/index.html.erb' if recipes.include? 'user_accounts'
  copy_from_repo 'app/views/home/index-subdomains.html.erb', :recipe => 'subdomains'
  ### USERS ###
  if recipes.include? 'user_accounts'
    ## INDEX
    copy_from_repo 'app/views/users/index.html.erb'
    ## SHOW
    copy_from_repo 'app/views/users/show.html.erb'
    copy_from_repo 'app/views/users/show-subdomains.html.erb', :recipe => 'subdomains'
    ## EDIT
    copy_from_repo 'app/views/users/edit-omniauth.html.erb', :recipe => 'omniauth'
  end
  ### PROFILES ###
  copy_from_repo 'app/views/profiles/show-subdomains.html.erb', :recipe => 'subdomains'
  ### GIT ###
  git :add => '.' if recipes.include? 'git'
  git :commit => "-aqm 'rails_apps_composer: views'" if recipes.include? 'git'
end # after_bundler

__END__

name: views
description: "Add views needed for starter apps."
author: RailsApps

run_after: [controllers]
category: other
tags: [utilities, configuration]