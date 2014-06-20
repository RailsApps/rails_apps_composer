# Application template recipe for the rails_apps_composer. Change the recipe here:
# https://github.com/RailsApps/rails_apps_composer/blob/master/recipes/tests.rb

stage_two do
  say_wizard "recipe stage two"
  if prefer :tests, 'rspec'
    say_wizard "recipe installing RSpec"
    generate 'testing:configure rspec -f'
  end
  if prefer :continuous_testing, 'guard'
    say_wizard "recipe initializing Guard"
    run 'bundle exec guard init'
  end
  git :add => '-A' if prefer :git, true
  git :commit => '-qm "rails_apps_composer: testing framework"' if prefer :git, true
end

stage_three do
  say_wizard "recipe stage three"
  if (prefer :authentication, 'devise') && (prefer :tests, 'rspec')
    generate 'testing:configure devise -f'
  end
  if (prefer :authentication, 'omniauth') && (prefer :tests, 'rspec')
    generate 'testing:configure omniauth -f'
  end
  if (prefer :authorization, 'pundit') && (prefer :tests, 'rspec')
    generate 'testing:configure pundit -f'
  end
end

__END__

name: tests
description: "Add testing framework."
author: RailsApps

requires: [setup, gems]
run_after: [setup, gems]
category: testing
