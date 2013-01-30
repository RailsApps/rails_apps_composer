# Application template recipe for the rails_apps_composer. Change the recipe here:
# https://github.com/RailsApps/rails_apps_composer/blob/master/recipes/testing.rb

after_bundler do
  say_wizard "recipe running after 'bundle install'"
  ### TEST/UNIT ###
  if prefer :unit_test, 'test_unit'
    inject_into_file 'config/application.rb', :after => "Rails::Application\n" do <<-RUBY

    config.generators do |g|
      #{"g.test_framework :test_unit, fixture_replacement: :fabrication" if prefer :fixtures, 'fabrication'}
      #{"g.fixture_replacement :fabrication, dir: 'test/fabricators'" if prefer :fixtures, 'fabrication'}
    end

RUBY
    end
  end
  ### RSPEC ###
  if prefer :unit_test, 'rspec'
    say_wizard "recipe installing RSpec"
    generate 'rspec:install'
    copy_from_repo 'spec/spec_helper.rb', :repo => 'https://raw.github.com/RailsApps/rails3-devise-rspec-cucumber/master/'
    generate 'email_spec:steps'
    inject_into_file 'spec/spec_helper.rb', "require 'email_spec'\n", :after => "require 'rspec/rails'\n"
    inject_into_file 'spec/spec_helper.rb', :after => "RSpec.configure do |config|\n" do <<-RUBY
  config.include(EmailSpec::Helpers)
  config.include(EmailSpec::Matchers)
RUBY
    end
    run 'rm -rf test/' # Removing test folder (not needed for RSpec)
    inject_into_file 'config/application.rb', :after => "Rails::Application\n" do <<-RUBY

    # don't generate RSpec tests for views and helpers
    config.generators do |g|
      #{"g.test_framework :rspec" if prefer :fixtures, 'none'}
      #{"g.test_framework :rspec, fixture: true" unless prefer :fixtures, 'none'}
      #{"g.fixture_replacement :factory_girl, dir: 'spec/factories'" if prefer :fixtures, 'factory_girl'}
      #{"g.fixture_replacement :machinist" if prefer :fixtures, 'machinist'}
      #{"g.fixture_replacement :fabrication" if prefer :fixtures, 'fabrication'}
      g.view_specs false
      g.helper_specs false
    end

RUBY
    end
    ## RSPEC AND MONGOID
    if prefer :orm, 'mongoid'
      # remove ActiveRecord artifacts
      gsub_file 'spec/spec_helper.rb', /config.fixture_path/, '# config.fixture_path'
      gsub_file 'spec/spec_helper.rb', /config.use_transactional_fixtures/, '# config.use_transactional_fixtures'
      # remove either possible occurrence of "require rails/test_unit/railtie"
      gsub_file 'config/application.rb', /require 'rails\/test_unit\/railtie'/, '# require "rails/test_unit/railtie"'
      gsub_file 'config/application.rb', /require "rails\/test_unit\/railtie"/, '# require "rails/test_unit/railtie"'
      # configure RSpec to use matchers from the mongoid-rspec gem
      create_file 'spec/support/mongoid.rb' do
      <<-RUBY
RSpec.configure do |config|
  config.include Mongoid::Matchers
end
RUBY
      end
    end
    ## RSPEC AND DEVISE
    if prefer :authentication, 'devise'
      # add Devise test helpers
      create_file 'spec/support/devise.rb' do
      <<-RUBY
RSpec.configure do |config|
  config.include Devise::TestHelpers, :type => :controller
end
RUBY
      end
    end
  end
  ### CUCUMBER ###
  if prefer :integration, 'cucumber'
    say_wizard "recipe installing Cucumber"
    generate "cucumber:install --capybara#{' --rspec' if prefer :unit_test, 'rspec'}#{' -D' if prefer :orm, 'mongoid'}"
    # make it easy to run Cucumber for single features without adding "--require features" to the command line
    gsub_file 'config/cucumber.yml', /std_opts = "/, 'std_opts = "-r features/support/ -r features/step_definitions '
    create_file 'features/support/email_spec.rb' do <<-RUBY
require 'email_spec/cucumber'
RUBY
    end
    ## CUCUMBER AND MONGOID
    if prefer :orm, 'mongoid'
      gsub_file 'features/support/env.rb', /transaction/, "truncation"
      inject_into_file 'features/support/env.rb', :after => 'begin' do
        "\n  DatabaseCleaner.orm = 'mongoid'"
      end
    end
    generate 'fabrication:cucumber_steps' if prefer :fixtures, 'fabrication'
  end
  ## TURNIP
  if prefer :integration, 'turnip'
    append_file '.rspec', '-r turnip/rspec'
    inject_into_file 'spec/spec_helper.rb', "require 'turnip/capybara'\n", :after => "require 'rspec/rails'\n"
    create_file 'spec/acceptance/steps/.gitkeep'
  end
  ## FIXTURE REPLACEMENTS
  if prefer :fixtures, 'machinist'
    say_wizard "generating blueprints file for 'machinist'"
    generate 'machinist:install'
  end
  ### GIT ###
  git :add => '-A' if prefer :git, true
  git :commit => '-qm "rails_apps_composer: testing framework"' if prefer :git, true
end # after_bundler

after_everything do
  say_wizard "recipe running after everything"
  ### RSPEC ###
  if prefer :unit_test, 'rspec'
    if (prefer :authentication, 'devise') && (prefer :starter_app, 'users_app')
      say_wizard "copying RSpec files from the rails3-devise-rspec-cucumber examples"
      repo = 'https://raw.github.com/RailsApps/rails3-devise-rspec-cucumber/master/'
      copy_from_repo 'spec/factories/users.rb', :repo => repo
      gsub_file 'spec/factories/users.rb', /# confirmed_at/, "confirmed_at" if (prefer :devise_modules, 'confirmable') || (prefer :devise_modules, 'invitable')
      copy_from_repo 'spec/controllers/home_controller_spec.rb', :repo => repo
      copy_from_repo 'spec/controllers/users_controller_spec.rb', :repo => repo
      copy_from_repo 'spec/models/user_spec.rb', :repo => repo
      remove_file 'spec/views/home/index.html.erb_spec.rb'
      remove_file 'spec/views/home/index.html.haml_spec.rb'
      remove_file 'spec/views/users/show.html.erb_spec.rb'
      remove_file 'spec/views/users/show.html.haml_spec.rb'
      remove_file 'spec/helpers/home_helper_spec.rb'
      remove_file 'spec/helpers/users_helper_spec.rb'
    end
    if (prefer :authentication, 'devise') && (prefer :starter_app, 'admin_app')
      say_wizard "copying RSpec files from the rails3-bootstrap-devise-cancan examples"
      repo = 'https://raw.github.com/RailsApps/rails3-bootstrap-devise-cancan/master/'
      copy_from_repo 'spec/factories/users.rb', :repo => repo
      gsub_file 'spec/factories/users.rb', /# confirmed_at/, "confirmed_at" if (prefer :devise_modules, 'confirmable') || (prefer :devise_modules, 'invitable')
      copy_from_repo 'spec/controllers/home_controller_spec.rb', :repo => repo
      copy_from_repo 'spec/controllers/users_controller_spec.rb', :repo => repo
      copy_from_repo 'spec/models/user_spec.rb', :repo => repo
      remove_file 'spec/views/home/index.html.erb_spec.rb'
      remove_file 'spec/views/home/index.html.haml_spec.rb'
      remove_file 'spec/views/users/show.html.erb_spec.rb'
      remove_file 'spec/views/users/show.html.haml_spec.rb'
      remove_file 'spec/helpers/home_helper_spec.rb'
      remove_file 'spec/helpers/users_helper_spec.rb'
    end
    ## RSPEC AND OMNIAUTH
    if (prefer :authentication, 'omniauth') && (prefer :starter_app, 'users_app')
      say_wizard "copying RSpec files from the rails3-mongoid-omniauth examples"
      repo = 'https://raw.github.com/RailsApps/rails3-mongoid-omniauth/master/'
      copy_from_repo 'spec/factories/users.rb', :repo => repo
      copy_from_repo 'spec/controllers/sessions_controller_spec.rb', :repo => repo
      copy_from_repo 'spec/controllers/home_controller_spec.rb', :repo => repo
      copy_from_repo 'spec/controllers/users_controller_spec.rb', :repo => repo
      copy_from_repo 'spec/models/user_spec.rb', :repo => repo
    end
    ## SUBDOMAINS
    if (prefer :authentication, 'devise') && (prefer :starter_app, 'subdomains_app')
      say_wizard "copying RSpec files from the rails3-subdomains examples"
      repo = 'https://raw.github.com/RailsApps/rails3-subdomains/master/'
      copy_from_repo 'spec/factories/users.rb', :repo => repo
      copy_from_repo 'spec/controllers/home_controller_spec.rb', :repo => repo
      copy_from_repo 'spec/controllers/users_controller_spec.rb', :repo => repo
      copy_from_repo 'spec/models/user_spec.rb', :repo => repo
    end
    ## GIT
    git :add => '-A' if prefer :git, true
    git :commit => '-qm "rails_apps_composer: rspec files"' if prefer :git, true
  end
  ### CUCUMBER ###
  if prefer :integration, 'cucumber'
    ## CUCUMBER AND DEVISE (USERS APP)
    if (prefer :authentication, 'devise') && (prefer :starter_app, 'users_app')
      say_wizard "copying Cucumber scenarios from the rails3-devise-rspec-cucumber examples"
      repo = 'https://raw.github.com/RailsApps/rails3-devise-rspec-cucumber/master/'
      copy_from_repo 'spec/controllers/home_controller_spec.rb', :repo => repo
      copy_from_repo 'features/users/sign_in.feature', :repo => repo
      copy_from_repo 'features/users/sign_out.feature', :repo => repo
      copy_from_repo 'features/users/sign_up.feature', :repo => repo
      copy_from_repo 'features/users/user_edit.feature', :repo => repo
      copy_from_repo 'features/users/user_show.feature', :repo => repo
      copy_from_repo 'features/step_definitions/user_steps.rb', :repo => repo
      copy_from_repo 'features/support/paths.rb', :repo => repo
      if (prefer :devise_modules, 'confirmable') || (prefer :devise_modules, 'invitable')
        gsub_file 'features/step_definitions/user_steps.rb', /Welcome! You have signed up successfully./, "A message with a confirmation link has been sent to your email address."
        inject_into_file 'features/users/sign_in.feature', :before => '    Scenario: User signs in successfully' do
<<-RUBY
  Scenario: User has not confirmed account
    Given I exist as an unconfirmed user
    And I am not logged in
    When I sign in with valid credentials
    Then I see an unconfirmed account message
    And I should be signed out
RUBY
        end
      end
    end
    ## CUCUMBER AND DEVISE (ADMIN APP)
    if (prefer :authentication, 'devise') && (prefer :starter_app, 'admin_app')
      say_wizard "copying Cucumber scenarios from the rails3-bootstrap-devise-cancan examples"
      repo = 'https://raw.github.com/RailsApps/rails3-bootstrap-devise-cancan/master/'
      copy_from_repo 'spec/controllers/home_controller_spec.rb', :repo => repo
      copy_from_repo 'features/users/sign_in.feature', :repo => repo
      copy_from_repo 'features/users/sign_out.feature', :repo => repo
      copy_from_repo 'features/users/sign_up.feature', :repo => repo
      copy_from_repo 'features/users/user_edit.feature', :repo => repo
      copy_from_repo 'features/users/user_show.feature', :repo => repo
      copy_from_repo 'features/step_definitions/user_steps.rb', :repo => repo
      copy_from_repo 'features/support/paths.rb', :repo => repo
      if (prefer :devise_modules, 'confirmable') || (prefer :devise_modules, 'invitable')
        gsub_file 'features/step_definitions/user_steps.rb', /Welcome! You have signed up successfully./, "A message with a confirmation link has been sent to your email address."
        inject_into_file 'features/users/sign_in.feature', :before => '    Scenario: User signs in successfully' do
<<-RUBY
  Scenario: User has not confirmed account
    Given I exist as an unconfirmed user
    And I am not logged in
    When I sign in with valid credentials
    Then I see an unconfirmed account message
    And I should be signed out
RUBY
        end
      end
    end
    ## CUCUMBER AND DEVISE (SUBDOMAINS APP)
    if (prefer :authentication, 'devise') && (prefer :starter_app, 'subdomains_app')
      say_wizard "copying RSpec files from the rails3-subdomains examples"
      repo = 'https://raw.github.com/RailsApps/rails3-subdomains/master/'
      copy_from_repo 'features/users/sign_in.feature', :repo => repo
      copy_from_repo 'features/users/sign_out.feature', :repo => repo
      copy_from_repo 'features/users/sign_up.feature', :repo => repo
      copy_from_repo 'features/users/user_edit.feature', :repo => repo
      copy_from_repo 'features/users/user_show.feature', :repo => repo
      copy_from_repo 'features/step_definitions/user_steps.rb', :repo => repo
      copy_from_repo 'features/support/paths.rb', :repo => repo
    end
    ## GIT
    git :add => '-A' if prefer :git, true
    git :commit => '-qm "rails_apps_composer: cucumber files"' if prefer :git, true
  end
  ### FABRICATION ###
  if prefer :fixtures, 'fabrication'
    say_wizard "replacing FactoryGirl fixtures with Fabrication"
    remove_file 'spec/factories/users.rb'
    remove_file 'spec/fabricators/user_fabricator.rb'
    create_file 'spec/fabricators/user_fabricator.rb' do
      <<-RUBY
Fabricator(:user) do
  name     'Test User'
  email    'example@example.com'
  password 'changeme'
  password_confirmation 'changeme'
  # required if the Devise Confirmable module is used
  # confirmed_at Time.now
end
RUBY
    end
    if prefer :integration, 'cucumber'
      gsub_file 'features/step_definitions/user_steps.rb', /@user = FactoryGirl.create\(:user, email: @visitor\[:email\]\)/, '@user = Fabricate(:user, email: @visitor[:email])'
    end
    if File.exist?('spec/controllers/users_controller_spec.rb')
      gsub_file 'spec/controllers/users_controller_spec.rb', /@user = FactoryGirl.create\(:user\)/, '@user = Fabricate(:user)'
    end
  end
end # after_everything

__END__

name: testing
description: "Add testing framework."
author: RailsApps

requires: [setup, gems]
run_after: [setup, gems]
category: testing
