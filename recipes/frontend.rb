# Application template recipe for the rails_apps_composer. Change the recipe here:
# https://github.com/RailsApps/rails_apps_composer/blob/master/recipes/frontend.rb

after_bundler do
  say_wizard "recipe running after 'bundle install'"
  ### LAYOUTS ###
  copy_from_repo 'app/views/layouts/application.html.erb'
  copy_from_repo 'app/views/layouts/application-bootstrap.html.erb', :prefs => 'bootstrap'
  copy_from_repo 'app/views/layouts/_messages.html.erb'
  copy_from_repo 'app/views/layouts/_messages-bootstrap.html.erb', :prefs => 'bootstrap'
  copy_from_repo 'app/views/layouts/_navigation.html.erb'
  if prefer :authorization, 'cancan'
    case prefs[:authentication]
      when 'devise'
        copy_from_repo 'app/views/layouts/_navigation-cancan.html.erb', :prefs => 'cancan'
      when 'omniauth'
        copy_from 'https://raw.github.com/RailsApps/rails-composer/master/files/app/views/layouts/_navigation-cancan-omniauth.html.erb', 'app/views/layouts/_navigation.html.erb'
    end
  else
    copy_from_repo 'app/views/layouts/_navigation-devise.html.erb', :prefs => 'devise'
    copy_from_repo 'app/views/layouts/_navigation-omniauth.html.erb', :prefs => 'omniauth'
  end
  copy_from_repo 'app/views/layouts/_navigation-subdomains_app.html.erb', :prefs => 'subdomains_app'  
  ## APPLICATION NAME
  application_layout_file = Dir['app/views/layouts/application.html.*'].first
  navigation_partial_file = Dir['app/views/layouts/_navigation.html.*'].first
  gsub_file application_layout_file, /App_Name/, "#{app_name.humanize.titleize}"
  gsub_file navigation_partial_file, /App_Name/, "#{app_name.humanize.titleize}"
  ### CSS ###
  copy_from_repo 'app/assets/stylesheets/application.css.scss'
  copy_from_repo 'app/assets/stylesheets/application-bootstrap.css.scss', :prefs => 'bootstrap'
  if prefer :bootstrap, 'less'
    generate 'bootstrap:install'
    insert_into_file 'app/assets/stylesheets/bootstrap_and_overrides.css.less', "body { padding-top: 60px; }\n", :after => "@import \"twitter/bootstrap/bootstrap\";\n"
  elsif prefer :bootstrap, 'sass'
    insert_into_file 'app/assets/javascripts/application.js', "//= require bootstrap\n", :after => "jquery_ujs\n"
    create_file 'app/assets/stylesheets/bootstrap_and_overrides.css.scss', <<-RUBY
@import "bootstrap";
body { padding-top: 60px; }
@import "bootstrap-responsive";
RUBY
  elsif prefer :frontend, 'foundation'
    insert_into_file 'app/assets/stylesheets/application.css.scss', " *= require foundation_and_overrides\n", :after => "require_self\n"
  elsif prefer :frontend, 'skeleton'
    copy_from 'https://raw.github.com/necolas/normalize.css/master/normalize.css', 'app/assets/stylesheets/normalize.css'
    copy_from 'https://raw.github.com/dhgamache/Skeleton/master/stylesheets/base.css', 'app/assets/stylesheets/base.css'
    copy_from 'https://raw.github.com/dhgamache/Skeleton/master/stylesheets/layout.css', 'app/assets/stylesheets/layout.css'
    copy_from 'https://raw.github.com/dhgamache/Skeleton/master/stylesheets/skeleton.css', 'app/assets/stylesheets/skeleton.css'
  elsif prefer :frontend, 'normalize'
    copy_from 'https://raw.github.com/necolas/normalize.css/master/normalize.css', 'app/assets/stylesheets/normalize.css'
  end
  remove_file 'app/assets/stylesheets/application.css'
  ### GIT ###
  git :add => '-A' if prefer :git, true
  git :commit => '-qm "rails_apps_composer: front-end framework"' if prefer :git, true
end # after_bundler

__END__

name: frontend
description: "Install a front-end framework for HTML5 and CSS."
author: RailsApps

requires: [setup, gems]
run_after: [setup, gems]
category: frontend
