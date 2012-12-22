# Application template recipe for the rails_apps_composer. Change the recipe here:
# https://github.com/RailsApps/rails_apps_composer/blob/master/recipes/saas.rb

if prefer :railsapps, 'rails-stripe-membership-saas'

  after_everything do
    say_wizard "recipe running after 'bundle install'"
    repo = 'https://raw.github.com/RailsApps/rails-stripe-membership-saas/master/'

    # >-------------------------------[ Clean up starter app ]--------------------------------<

    %w{
      public/index.html
      app/assets/images/rails.png
    }.each { |file| remove_file file }
    # remove commented lines and multiple blank lines from Gemfile
    # thanks to https://github.com/perfectline/template-bucket/blob/master/cleanup.rb
    gsub_file 'Gemfile', /#.*\n/, "\n"
    gsub_file 'Gemfile', /\n^\s*\n/, "\n"
    # remove commented lines and multiple blank lines from config/routes.rb
    gsub_file 'config/routes.rb', /  #.*\n/, "\n"
    gsub_file 'config/routes.rb', /\n^\s*\n/, "\n"
    # GIT
    git :add => '-A' if prefer :git, true
    git :commit => '-qm "rails_apps_composer: clean up starter app"' if prefer :git, true

    # >-------------------------------[ Migrations ]--------------------------------<
    generate 'migration AddStripeToUsers customer_id:string last_4_digits:string'
    run 'bundle exec rake db:drop'
    run 'bundle exec rake db:migrate'

    # >-------------------------------[ Models ]--------------------------------<
    copy_from_repo 'app/models/ability.rb', :repo => repo
    copy_from_repo 'app/models/user.rb', :repo => repo

    # >-------------------------------[ Init ]--------------------------------<
    copy_from_repo 'config/application.yml', :repo => repo
    remove_file 'config/application.example.yml'
    copy_file destination_root + '/config/application.yml', destination_root + '/config/application.example.yml'
    copy_from_repo 'db/seeds.rb', :repo => repo
    copy_from_repo 'config/initializers/stripe.rb', :repo => repo
    run 'bundle exec rake db:seed'
    run 'bundle exec rake db:test:prepare'

    # >-------------------------------[ Controllers ]--------------------------------<
    copy_from_repo 'app/controllers/home_controller.rb', :repo => repo
    generate 'controller content silver gold platinum --skip-stylesheets --skip-javascripts'
    copy_from_repo 'app/controllers/content_controller.rb', :repo => repo
    copy_from_repo 'app/controllers/registrations_controller.rb', :repo => repo
    copy_from_repo 'app/controllers/application_controller.rb', :repo => repo
    copy_from_repo 'app/controllers/users_controller.rb', :repo => repo

    # >-------------------------------[ Mailers ]--------------------------------<
    generate 'mailer UserMailer'
    copy_from_repo 'app/mailers/user_mailer.rb', :repo => repo

    # >-------------------------------[ Views ]--------------------------------<
    copy_from_repo 'app/views/home/index.html.erb', :repo => repo
    copy_from_repo 'app/views/layouts/_navigation.html.erb', :repo => repo
    copy_from_repo 'app/views/devise/registrations/new.html.erb', :repo => repo
    copy_from_repo 'app/views/devise/registrations/edit.html.erb', :repo => repo
    copy_from_repo 'app/views/user_mailer/expire_email.html.erb', :repo => repo
    copy_from_repo 'app/views/user_mailer/expire_email.text.erb', :repo => repo

    # >-------------------------------[ Routes ]--------------------------------<
    copy_from_repo 'config/routes.rb', :repo => repo
    ### CORRECT APPLICATION NAME ###
    gsub_file 'config/routes.rb', /^.*.routes.draw do/, "#{app_const}.routes.draw do"

    # >-------------------------------[ Assets ]--------------------------------<
    copy_from_repo 'app/assets/javascripts/application.js', :repo => repo
    copy_from_repo 'app/assets/javascripts/jquery.readyselector.js', :repo => repo
    copy_from_repo 'app/assets/javascripts/jquery.externalscript.js', :repo => repo
    copy_from_repo 'app/assets/javascripts/registrations.js', :repo => repo
    copy_from_repo 'app/assets/stylesheets/application.css.scss', :repo => repo
    copy_from_repo 'app/assets/stylesheets/pricing.css.scss', :repo => repo

    # >-------------------------------[ RSpec ]--------------------------------<
    say_wizard "copying RSpec tests from the rails-stripe-membership-saas examples"
    copy_from_repo 'spec/factories/roles.rb', :repo => repo
    copy_from_repo 'spec/models/user_spec.rb', :repo => repo
    copy_from_repo 'spec/controllers/content_controller_spec.rb', :repo => repo
    copy_from_repo 'spec/mailers/user_mailer_spec.rb', :repo => repo
    copy_from_repo 'spec/stripe/stripe_config_spec.rb', :repo => repo
    copy_from_repo 'spec/support/stripe_helper.rb', :repo => repo
    copy_from_repo 'spec/support/fixtures/success.json', :repo => repo

    # >-------------------------------[ Cucumber ]--------------------------------<
    say_wizard "copying Cucumber scenarios from the rails-stripe-membership-saas examples"
    remove_file 'features/users/user_show.feature'
    copy_from_repo 'features/support/paths.rb', :repo => repo
    copy_from_repo 'features/users/sign_in.feature', :repo => repo
    copy_from_repo 'features/users/sign_up.feature', :repo => repo
    copy_from_repo 'features/users/sign_up_with_stripe.feature', :repo => repo
    copy_from_repo 'features/users/user_edit.feature', :repo => repo
    copy_from_repo 'features/users/user_delete.feature', :repo => repo
    copy_from_repo 'features/step_definitions/user_steps.rb', :repo => repo
    copy_from_repo 'features/step_definitions/form_helper_steps.rb', :repo => repo
    copy_from_repo 'config/locales/devise.en.yml', :repo => repo

    ### GIT ###
    git :add => '-A' if prefer :git, true
    git :commit => '-qm "rails_apps_composer: membership app"' if prefer :git, true
  end # after_bundler
end # rails-stripe-membership-saas

if prefer :railsapps, 'rails-recurly-subscription-saas'

  after_everything do
    say_wizard "recipe running after 'bundle install'"
    repo = 'https://raw.github.com/RailsApps/rails-recurly-subscription-saas/master/'

    # >-------------------------------[ Clean up starter app ]--------------------------------<

    %w{
      public/index.html
      app/assets/images/rails.png
    }.each { |file| remove_file file }
    # remove commented lines and multiple blank lines from Gemfile
    # thanks to https://github.com/perfectline/template-bucket/blob/master/cleanup.rb
    gsub_file 'Gemfile', /#.*\n/, "\n"
    gsub_file 'Gemfile', /\n^\s*\n/, "\n"
    # remove commented lines and multiple blank lines from config/routes.rb
    gsub_file 'config/routes.rb', /  #.*\n/, "\n"
    gsub_file 'config/routes.rb', /\n^\s*\n/, "\n"
    # GIT
    git :add => '-A' if prefer :git, true
    git :commit => '-qm "rails_apps_composer: clean up starter app"' if prefer :git, true

    # >-------------------------------[ Migrations ]--------------------------------<
    generate 'migration AddRecurlyToUsers first_name:string last_name:string customer_id:string'
    run 'bundle exec rake db:drop'
    run 'bundle exec rake db:migrate'

    # >-------------------------------[ Models ]--------------------------------<
    copy_from_repo 'app/models/ability.rb', :repo => repo
    copy_from_repo 'app/models/user.rb', :repo => repo

    # >-------------------------------[ Init ]--------------------------------<
    copy_from_repo 'config/application.yml', :repo => repo
    remove_file 'config/application.example.yml'
    copy_file destination_root + '/config/application.yml', destination_root + '/config/application.example.yml'
    copy_from_repo 'db/seeds.rb', :repo => repo
    copy_from_repo 'config/initializers/recurly.rb', :repo => repo
    run 'bundle exec rake db:seed'
    run 'bundle exec rake db:test:prepare'

    # >-------------------------------[ Controllers ]--------------------------------<
    copy_from_repo 'app/controllers/home_controller.rb', :repo => repo
    generate 'controller content silver gold platinum --skip-stylesheets --skip-javascripts'
    copy_from_repo 'app/controllers/content_controller.rb', :repo => repo
    copy_from_repo 'app/controllers/registrations_controller.rb', :repo => repo
    copy_from_repo 'app/controllers/application_controller.rb', :repo => repo
    copy_from_repo 'app/controllers/users_controller.rb', :repo => repo
    copy_from_repo 'app/controllers/recurly_controller.rb', :repo => repo

    # >-------------------------------[ Mailers ]--------------------------------<
    generate 'mailer UserMailer'
    copy_from_repo 'app/mailers/user_mailer.rb', :repo => repo

    # >-------------------------------[ Views ]--------------------------------<
    copy_from_repo 'app/views/home/index.html.erb', :repo => repo
    copy_from_repo 'app/views/layouts/_navigation.html.erb', :repo => repo
    copy_from_repo 'app/views/devise/registrations/new.html.erb', :repo => repo
    copy_from_repo 'app/views/devise/registrations/edit.html.erb', :repo => repo
    copy_from_repo 'app/views/user_mailer/expire_email.html.erb', :repo => repo
    copy_from_repo 'app/views/user_mailer/expire_email.text.erb', :repo => repo

    # >-------------------------------[ Routes ]--------------------------------<
    copy_from_repo 'config/routes.rb', :repo => repo
    ### CORRECT APPLICATION NAME ###
    gsub_file 'config/routes.rb', /^.*.routes.draw do/, "#{app_const}.routes.draw do"

    # >-------------------------------[ Assets ]--------------------------------<
    copy_from_repo 'app/assets/javascripts/application.js', :repo => repo
    copy_from_repo 'app/assets/javascripts/jquery.readyselector.js', :repo => repo
    copy_from_repo 'app/assets/javascripts/recurly.js', :repo => repo
    copy_from_repo 'app/assets/javascripts/registrations.js', :repo => repo
    copy_from_repo 'app/assets/stylesheets/application.css.scss', :repo => repo
    copy_from_repo 'app/assets/stylesheets/pricing.css.scss', :repo => repo

    # >-------------------------------[ RSpec ]--------------------------------<
    say_wizard "copying RSpec tests from the rails-recurly-subscription-saas examples"
    copy_from_repo 'spec/factories/roles.rb', :repo => repo
    copy_from_repo 'spec/factories/users.rb', :repo => repo
    copy_from_repo 'spec/models/user_spec.rb', :repo => repo
    copy_from_repo 'spec/controllers/content_controller_spec.rb', :repo => repo
    copy_from_repo 'spec/mailers/user_mailer_spec.rb', :repo => repo
    copy_from_repo 'spec/recurly/recurly_config_spec.rb', :repo => repo

    # >-------------------------------[ Cucumber ]--------------------------------<
    say_wizard "copying Cucumber scenarios from the rails-recurly-subscription-saas examples"
    remove_file 'features/users/user_show.feature'
    copy_from_repo 'features/support/paths.rb', :repo => repo
    copy_from_repo 'features/users/sign_in.feature', :repo => repo
    copy_from_repo 'features/users/sign_up.feature', :repo => repo
    copy_from_repo 'features/users/sign_up_with_recurly.feature', :repo => repo
    copy_from_repo 'features/users/user_edit.feature', :repo => repo
    copy_from_repo 'features/users/user_delete.feature', :repo => repo
    copy_from_repo 'features/step_definitions/user_steps.rb', :repo => repo
    copy_from_repo 'features/step_definitions/form_helper_steps.rb', :repo => repo
    copy_from_repo 'config/locales/devise.en.yml', :repo => repo

    ### GIT ###
    git :add => '-A' if prefer :git, true
    git :commit => '-qm "rails_apps_composer: membership app"' if prefer :git, true
  end # after_bundler
end # rails-recurly-subscription-saas

__END__

name: prelaunch
description: "Install an example application for a membership site."
author: RailsApps

requires: [core]
run_after: [setup, gems, models, controllers, views, frontend, init]
category: apps
