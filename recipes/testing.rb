# Application template recipe for the rails_apps_composer. Change the recipe here:
# https://github.com/RailsApps/rails_apps_composer/blob/master/recipes/testing.rb

after_bundler do
  say_wizard "recipe running after 'bundle install'"
  ### RSPEC ###
  if recipes.include? 'rspec'
    say_wizard "recipe installing RSpec"
    generate 'rspec:install'
    if recipes.include? 'email'
      generate 'email_spec:steps'
      inject_into_file 'spec/spec_helper.rb', "require 'email_spec'\n", :after => "require 'rspec/rails'\n"
      inject_into_file 'spec/spec_helper.rb', :after => "RSpec.configure do |config|\n" do <<-RUBY
  config.include(EmailSpec::Helpers)
  config.include(EmailSpec::Matchers)
RUBY
      end
    end
    run 'rm -rf test/' # Removing test folder (not needed for RSpec)
    inject_into_file 'config/application.rb', :after => "Rails::Application\n" do <<-RUBY

    # don't generate RSpec tests for views and helpers
    config.generators do |g|
      g.view_specs false
      g.helper_specs false
      #{"g.fixture_replacement :machinist" if recipes.include? 'machinist'}
    end

RUBY
    end
    ## RSPEC AND MONGOID
    if recipes.include? 'mongoid'
      # remove ActiveRecord artifacts
      gsub_file 'spec/spec_helper.rb', /config.fixture_path/, '# config.fixture_path'
      gsub_file 'spec/spec_helper.rb', /config.use_transactional_fixtures/, '# config.use_transactional_fixtures'
      # reset your application database to a pristine state during testing
      inject_into_file 'spec/spec_helper.rb', :before => "\nend" do
      <<-RUBY
  \n
  require 'database_cleaner'
  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.orm = "mongoid"
  end

  config.before(:each) do
    DatabaseCleaner.clean
  end
RUBY
      end
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
    if recipes.include? 'devise'
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
  if recipes.include? 'cucumber'
    say_wizard "recipe installing Cucumber"
    generate "cucumber:install --capybara#{' --rspec' if recipes.include?('rspec')}#{' -D' if recipes.include?('mongoid')}"
    # make it easy to run Cucumber for single features without adding "--require features" to the command line
    gsub_file 'config/cucumber.yml', /std_opts = "/, 'std_opts = "-r features/support/ -r features/step_definitions '
    if recipes.include? 'email'
      create_file 'features/support/email_spec.rb' do <<-RUBY
require 'email_spec/cucumber'
RUBY
      end      
    end
    ## CUCUMBER AND MONGOID
    if recipes.include? 'mongoid'
      gsub_file 'features/support/env.rb', /transaction/, "truncation"
      inject_into_file 'features/support/env.rb', :after => 'begin' do
        "\n  DatabaseCleaner.orm = 'mongoid'"
      end
    end
  end
  ## TURNIP
  if recipes.include? 'turnip'
    append_to_file '.rspec', '-r turnip/rspec'
    inject_into_file 'spec/spec_helper.rb', "require 'turnip/capybara'\n", :after => "require 'rspec/rails'\n"
    create_file 'spec/acceptance/steps/.gitkeep'
  end
  ## FIXTURE REPLACEMENTS
  if recipes.include? 'machinist'
    say_wizard "generating blueprints file for 'machinist'"
    generate 'machinist:install'
  end
  ### GIT ###
  git :add => '.' if recipes.include? 'git'
  git :commit => "-aqm 'rails_apps_composer: testing framework'" if recipes.include? 'git'
end # after_bundler

after_everything do
  say_wizard "recipe running after everything"
  ### RSPEC ###
  if recipes.include? 'rspec'
    if (recipes.include? 'devise') && (recipes.include? 'user_accounts')
      say_wizard "copying RSpec files from the rails3-devise-rspec-cucumber examples"
      repo = 'https://raw.github.com/RailsApps/rails3-devise-rspec-cucumber/master/'
      copy_from_repo 'spec/factories/users.rb', :repo => repo
      gsub_file 'spec/factories/users.rb', /# confirmed_at/, "confirmed_at" if recipes.include? 'devise-confirmable'
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
    if (recipes.include? 'omniauth') && (recipes.include? 'user_accounts')
      say_wizard "copying RSpec files from the rails3-mongoid-omniauth examples"
      repo = 'https://raw.github.com/RailsApps/rails3-mongoid-omniauth/master/'
      copy_from_repo 'spec/spec_helper.rb', :repo => repo
      copy_from_repo 'spec/factories/users.rb', :repo => repo
      copy_from_repo 'spec/controllers/sessions_controller_spec.rb', :repo => repo
      copy_from_repo 'spec/controllers/home_controller_spec.rb', :repo => repo
      copy_from_repo 'spec/controllers/users_controller_spec.rb', :repo => repo
      copy_from_repo 'spec/models/user_spec.rb', :repo => repo
    end
    ## GIT
    git :add => '.' if recipes.include? 'git'
    git :commit => "-aqm 'rails_apps_composer: rspec files'" if recipes.include? 'git'
  end
  ### CUCUMBER ###
  if recipes.include? 'cucumber'
    ## CUCUMBER AND DEVISE
    if (recipes.include? 'devise') && (recipes.include? 'user_accounts')
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
      if recipes.include? 'devise-confirmable'
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
    ## GIT
    git :add => '.' if recipes.include? 'git'
    git :commit => "-aqm 'rails_apps_composer: cucumber files'" if recipes.include? 'git'
  end
end # after_everything 
  
__END__

name: testing
description: "Add testing framework."
author: RailsApps

category: testing

args: ["-T"]
