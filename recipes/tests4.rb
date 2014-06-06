# Application template recipe for the rails_apps_composer. Change the recipe here:
# https://github.com/RailsApps/rails_apps_composer/blob/master/recipes/tests4.rb

after_bundler do
  say_wizard "recipe running after 'bundle install'"
  ### RSPEC ###
  if prefer :tests, 'rspec'
    say_wizard "recipe installing RSpec"
    generate 'testing:configure rspec -f'
  end
  ### GUARD ###
  if prefer :continuous_testing, 'guard'
    say_wizard "recipe initializing Guard"
    run 'bundle exec guard init'
  end
  ### GIT ###
  git :add => '-A' if prefer :git, true
  git :commit => '-qm "rails_apps_composer: testing framework"' if prefer :git, true
end # after_bundler

after_everything do
  say_wizard "recipe running after everything"
  if (prefer :authentication, 'devise') && (prefer :tests, 'rspec')
    generate 'testing:configure devise -f'
  end
  if (prefer :authentication, 'omniauth') && (prefer :tests, 'rspec')
    generate 'testing:configure omniauth -f'
  end
end # after_everything

__END__

name: tests4
description: "Add testing framework."
author: RailsApps

requires: [setup, gems]
run_after: [setup, gems]
category: testing
