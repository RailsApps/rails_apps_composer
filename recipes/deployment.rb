# Application template recipe for the rails_apps_composer. Change the recipe here:
# https://github.com/RailsApps/rails_apps_composer/blob/master/recipes/deployment.rb

case config['deployment']
when 'capistrano3'
  prefs[:deployment] = 'capistrano3'
end

if prefer :deployment, 'capistrano3'
  say_wizard "recipe adding capistrano gems"
  add_gem 'capistrano', '~> 3.0.1', group: :development
  add_gem 'capistrano-rvm', '~> 0.1.1', group: :development
  add_gem 'capistrano-bundler', group: :development
  add_gem 'capistrano-rails', '~> 1.1.0', group: :development
  add_gem 'capistrano-rails-console', group: :development
  after_bundler do
    say_wizard 'recipe capistrano file'
    run 'bundle exec cap install'
  end
end

__END__

name: deployment
description: "Capistrano3-deployment - more options can be added later"
author: zealot128

category: development
requires: [setup]
run_after: [extras]
args: -T

config:
  - deployment:
      type: multiple_choice
      prompt: Add a deployment mechanism?
      choices: [["None", "none"], ["Capistrano3", "capistrano3"] ]
