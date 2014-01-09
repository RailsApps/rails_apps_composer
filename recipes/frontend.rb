# Application template recipe for the rails_apps_composer. Change the recipe here:
# https://github.com/RailsApps/rails_apps_composer/blob/master/recipes/frontend.rb

after_bundler do
  say_wizard "recipe running after 'bundle install'"
  # set up a front-end framework using the rails_layout gem
  case prefs[:frontend]
    when 'simple'
      generate 'layout:install simple -f'
    when 'bootstrap2'
      generate 'layout:install bootstrap2 -f'
    when 'bootstrap3'
      generate 'layout:install bootstrap3 -f'
    when 'foundation4'
      generate 'layout:install foundation4 -f'
    when 'foundation5'
      generate 'layout:install foundation5 -f'
  end
  # generate Devise views with appropriate styling
  if prefer :authentication, 'devise'
    case prefs[:frontend]
      when 'bootstrap3'
        generate 'layout:devise bootstrap3 -f'
      when 'foundation5'
        generate 'layout:devise foundation5 -f'
    end
  end

  ### GIT ###
  git :add => '-A' if prefer :git, true
  git :commit => '-qm "rails_apps_composer: front-end framework"' if prefer :git, true
end # after_bundler

after_everything do
  say_wizard "recipe running after everything"
  # create navigation links using the rails_layout gem
  generate 'layout:navigation -f'
  # replace with specialized navigation partials
  if prefer :authentication, 'omniauth'
    if prefer :authorization, 'cancan'
      copy_from 'https://raw.github.com/RailsApps/rails-composer/master/files/app/views/layouts/_navigation-cancan-omniauth.html.erb', 'app/views/layouts/_navigation.html.erb'
    else
      copy_from_repo 'app/views/layouts/_navigation-omniauth.html.erb', :prefs => 'omniauth'
    end
  end
  copy_from_repo 'app/views/layouts/_navigation-subdomains_app.html.erb', :prefs => 'subdomains_app'

  ### GIT ###
  git :add => '-A' if prefer :git, true
  git :commit => '-qm "rails_apps_composer: navigation links"' if prefer :git, true
end # after_everything

__END__

name: frontend
description: "Install a front-end framework for HTML5 and CSS."
author: RailsApps

requires: [setup, gems]
run_after: [setup, gems]
category: frontend
