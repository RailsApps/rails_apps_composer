# Application template recipe for the rails_apps_composer. Change the recipe here:
# https://github.com/RailsApps/rails_apps_composer/blob/master/recipes/frontend.rb

after_bundler do
  say_wizard "recipe running after 'bundle install'"
  # set up a front-end framework using the rails_layout gem
  case prefs[:frontend]
    when 'simple'
      generate 'layout simple -f'
    when 'bootstrap2'
      generate 'layout bootstrap2 -f'
    when 'bootstrap3'
      generate 'layout bootstrap3 -f'
    when 'foundation4'
      generate 'layout foundation4 -f'
  end

  # specialized navigation partials
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
