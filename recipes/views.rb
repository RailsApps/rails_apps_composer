# Application template recipe for the rails_apps_composer. Change the recipe here:
# https://github.com/RailsApps/rails_apps_composer/blob/master/recipes/views.rb

after_bundler do
  say_wizard "recipe running after 'bundle install'"
  repo = 'https://raw.github.com/RailsApps/rails3-application-templates/master/files-v2/'
  ### DEVISE ###
  copy_from_repo 'app/views/devise/shared/_links.html.erb', repo if recipes.include? 'devise'
  copy_from_repo 'app/views/devise/registrations/edit.html.erb', repo if recipes.include? 'devise'
  copy_from_repo 'app/views/devise/registrations/new.html.erb', repo if recipes.include? 'devise'
  ### HOME ###
  copy_from_repo 'app/views/home/index.html.erb', repo if recipes.include? 'user_accounts'
  ### USERS ###
  if recipes.include? 'user_accounts'
    ## INDEX
    copy_from_repo 'app/views/users/index.html.erb', repo
    copy_from_repo 'app/views/users/index-paginate.html.erb', repo, :recipe => 'paginate'
    ## SHOW
    copy_from_repo 'app/views/users/show.html.erb', repo
    ## EDIT
    copy_from_repo 'app/views/users/edit-omniauth.html.erb', repo, :recipe => 'omniauth'
  end
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