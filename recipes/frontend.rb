# Application template recipe for the rails_apps_composer. Change the recipe here:
# https://github.com/RailsApps/rails_apps_composer/blob/master/recipes/frontend.rb

after_bundler do
  say_wizard "recipe running after 'bundle install'"
  repo = 'https://raw.github.com/RailsApps/rails3-application-templates/master/files-v2/'  
  ### NAVIGATION ###
  copy_from_repo 'app/views/layouts/_navigation.html.erb', repo
  copy_from_repo 'app/views/layouts/_navigation-devise.html.erb', repo, :recipe => 'devise'
  copy_from_repo 'app/views/layouts/_navigation-cancan.html.erb', repo, :recipe => 'cancan'
  copy_from_repo 'app/views/layouts/_navigation-omniauth.html.erb', repo, :recipe => 'omniauth'
  copy_from_repo 'app/views/layouts/_navigation-subdomains.html.erb', repo, :recipe => 'subdomains'
  ### LAYOUTS ###
  ## SIMPLE
  copy_from_repo 'app/views/layouts/application.html.erb', repo
  copy_from_repo 'app/views/layouts/_messages.html.erb', repo
  ## TWITTER BOOTSTRAP
  copy_from_repo 'app/views/layouts/application-bootstrap.html.erb', repo, :recipe => 'bootstrap'
  copy_from_repo 'app/views/layouts/_messages-bootstrap.html.erb', repo, :recipe => 'bootstrap'
  if recipes.include? 'haml'
    gsub_file 'app/views/layouts/application.html.haml', /App_Name/, "#{app_name.humanize.titleize}"
    gsub_file 'app/views/layouts/_navigation.html.haml', /App_Name/, "#{app_name.humanize.titleize}"
  else
    gsub_file 'app/views/layouts/application.html.erb', /App_Name/, "#{app_name.humanize.titleize}"
    gsub_file 'app/views/layouts/_navigation.html.erb', /App_Name/, "#{app_name.humanize.titleize}"
  end
  ### CSS ###
  remove_file 'app/assets/stylesheets/application.css'
  copy_from_repo 'app/assets/stylesheets/application.css.scss', repo
  copy_from_repo 'app/assets/stylesheets/application-bootstrap.css.scss', repo, :recipe => 'bootstrap'
  if recipes.include? 'bootstrap_less'
    generate 'bootstrap:install'
    insert_into_file 'app/assets/stylesheets/bootstrap_and_overrides.css.less', "body { padding-top: 60px; }\n", :after => "@import \"twitter/bootstrap/bootstrap\";\n"
  elsif recipes.include? 'bootstrap_sass'
    insert_into_file 'app/assets/javascripts/application.js', "//= require bootstrap\n", :after => "jquery_ujs\n"
    create_file 'app/assets/stylesheets/bootstrap_and_overrides.css.scss', <<-RUBY
@import "bootstrap";
body { padding-top: 60px; }
@import "bootstrap-responsive";
RUBY
  elsif recipes.include? 'foundation'
    insert_into_file 'app/assets/javascripts/application.js', "//= require foundation\n", :after => "jquery_ujs\n"
    insert_into_file 'app/assets/stylesheets/application.css.scss', " *= require foundation\n", :after => "require_self\n"
  elsif recipes.include? 'skeleton'
    copy_from_repo 'app/assets/stylesheets/normalize.css.scss', 'https://raw.github.com/necolas/normalize.css/master/normalize.css'
    copy_from_repo 'app/assets/stylesheets/base.css.scss', 'https://raw.github.com/dhgamache/Skeleton/master/stylesheets/base.css'
    copy_from_repo 'app/assets/stylesheets/layout.css.scss', 'https://raw.github.com/dhgamache/Skeleton/master/stylesheets/layout.css'
    copy_from_repo 'app/assets/stylesheets/skeleton.css.scss', 'https://raw.github.com/dhgamache/Skeleton/master/stylesheets/skeleton.css'
  elsif recipes.include? 'normalize'
    copy_from_repo 'app/assets/stylesheets/normalize.css.scss', 'https://raw.github.com/necolas/normalize.css/master/normalize.css'
  end
  ### GIT ###
  git :add => '.' if recipes.include? 'git'
  git :commit => "-aqm 'rails_apps_composer: front-end framework'" if recipes.include? 'git'
end # after_bundler

__END__

name: frontend
description: "Install a front-end framework for HTML5 and CSS."
author: RailsApps

category: other
tags: [utilities, configuration]
