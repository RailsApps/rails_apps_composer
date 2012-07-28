# Application template recipe for the rails_apps_composer. Change the recipe here:
# https://github.com/RailsApps/rails_apps_composer/blob/master/recipes/frontend.rb

after_bundler do
  say_wizard "recipe running after 'bundle install'"
  ### LAYOUTS ###
  copy_from_repo 'app/views/layouts/application.html.erb'
  copy_from_repo 'app/views/layouts/application-bootstrap.html.erb', :recipe => 'bootstrap'
  copy_from_repo 'app/views/layouts/_messages.html.erb'
  copy_from_repo 'app/views/layouts/_messages-bootstrap.html.erb', :recipe => 'bootstrap'
  copy_from_repo 'app/views/layouts/_navigation.html.erb'
  copy_from_repo 'app/views/layouts/_navigation-devise.html.erb', :recipe => 'devise'
  copy_from_repo 'app/views/layouts/_navigation-cancan.html.erb', :recipe => 'cancan'
  copy_from_repo 'app/views/layouts/_navigation-omniauth.html.erb', :recipe => 'omniauth'
  copy_from_repo 'app/views/layouts/_navigation-subdomains.html.erb', :recipe => 'subdomains'  
  ## APPLICATION NAME
  application_layout_file = 'app/views/layouts/application.html.erb'
  application_layout_file = 'app/views/layouts/application.html.haml' if recipes.include? 'haml'
  application_layout_file = 'app/views/layouts/application.html.slim' if recipes.include? 'slim'
  navigation_partial_file = 'app/views/layouts/_navigation.html.erb'
  navigation_partial_file = 'app/views/layouts/_navigation.html.haml' if recipes.include? 'haml'
  navigation_partial_file = 'app/views/layouts/_navigation.html.slim' if recipes.include? 'slim'
  gsub_file application_layout_file, /App_Name/, "#{app_name.humanize.titleize}"
  gsub_file navigation_partial_file, /App_Name/, "#{app_name.humanize.titleize}"
  ### CSS ###
  remove_file 'app/assets/stylesheets/application.css'
  copy_from_repo 'app/assets/stylesheets/application.css.scss'
  copy_from_repo 'app/assets/stylesheets/application-bootstrap.css.scss', :recipe => 'bootstrap'
  if recipes.include? 'bootstrap-less'
    generate 'bootstrap:install'
    insert_into_file 'app/assets/stylesheets/bootstrap_and_overrides.css.less', "body { padding-top: 60px; }\n", :after => "@import \"twitter/bootstrap/bootstrap\";\n"
  elsif recipes.include? 'bootstrap-sass'
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
    copy_from_repo 'app/assets/stylesheets/normalize.css.scss', :repo => 'https://raw.github.com/necolas/normalize.css/master/normalize.css'
    copy_from_repo 'app/assets/stylesheets/base.css.scss', :repo => 'https://raw.github.com/dhgamache/Skeleton/master/stylesheets/base.css'
    copy_from_repo 'app/assets/stylesheets/layout.css.scss', :repo => 'https://raw.github.com/dhgamache/Skeleton/master/stylesheets/layout.css'
    copy_from_repo 'app/assets/stylesheets/skeleton.css.scss', :repo => 'https://raw.github.com/dhgamache/Skeleton/master/stylesheets/skeleton.css'
  elsif recipes.include? 'normalize'
    copy_from_repo 'app/assets/stylesheets/normalize.css.scss', :repo => 'https://raw.github.com/necolas/normalize.css/master/normalize.css'
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
