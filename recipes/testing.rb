# Application template recipe for the rails_apps_composer. Check for a newer version here:
# https://github.com/RailsApps/rails_apps_composer/blob/master/recipes/testing.rb

### RSPEC AND FIXTURE REPLACEMENTS ###

if recipes.include? 'rspec'
  after_bundler do
    say_wizard "RSpec recipe running 'after bundler'"
    generate 'rspec:install'
    generate 'email_spec:steps'
    inject_into_file 'spec/spec_helper.rb', "require 'email_spec'\n", :after => "require 'rspec/rails'\n"
    inject_into_file 'spec/spec_helper.rb', :after => "RSpec.configure do |config|\n" do <<-RUBY
  config.include(EmailSpec::Helpers)
  config.include(EmailSpec::Matchers)
RUBY
    end
    if recipes.include? 'machinist'
      say_wizard "Generating blueprints file for Machinist"
      generate 'machinist:install'
    end

    say_wizard "Removing test folder (not needed for RSpec)"
    run 'rm -rf test/'

    inject_into_file 'config/application.rb', :after => "Rails::Application\n" do <<-RUBY

    # don't generate RSpec tests for views and helpers
    config.generators do |g|
      g.view_specs false
      g.helper_specs false
      #{"g.fixture_replacement :machinist" if config['fixtures'] === 'machinist'}
    end

RUBY
    end


    if recipes.include? 'mongoid'

      # remove ActiveRecord artifacts
      gsub_file 'spec/spec_helper.rb', /config.fixture_path/, '# config.fixture_path'
      gsub_file 'spec/spec_helper.rb', /config.use_transactional_fixtures/, '# config.use_transactional_fixtures'

      # reset your application database to a pristine state during testing
      inject_into_file 'spec/spec_helper.rb', :before => "\nend" do
      <<-RUBY
  \n
  # Clean up the database
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
end

### CUCUMBER ###

if recipes.include? 'cucumber'
  after_bundler do
    say_wizard "Cucumber recipe running 'after bundler'"
    generate "cucumber:install --capybara#{' --rspec' if recipes.include?('rspec')}#{' -D' if recipes.include?('mongoid')}"
    # make it easy to run Cucumber for single features without adding "--require features" to the command line
    gsub_file 'config/cucumber.yml', /std_opts = "/, 'std_opts = "-r features/support/ -r features/step_definitions '
    if recipes.include? 'mongoid'
      gsub_file 'features/support/env.rb', /transaction/, "truncation"
      inject_into_file 'features/support/env.rb', :after => 'begin' do
        "\n  DatabaseCleaner.orm = 'mongoid'"
      end
    end
  end
end

if recipes.include? 'cucumber'
  if recipes.include? 'devise'
    after_bundler do
      say_wizard "Copying Cucumber scenarios from the rails3-devise-rspec-cucumber examples"
      begin
        # copy all the Cucumber scenario files from the rails3-devise-rspec-cucumber example app
        get 'https://raw.github.com/RailsApps/rails3-devise-rspec-cucumber/master/features/users/sign_in.feature', 'features/users/sign_in.feature'
        get 'https://raw.github.com/RailsApps/rails3-devise-rspec-cucumber/master/features/users/sign_out.feature', 'features/users/sign_out.feature'
        get 'https://raw.github.com/RailsApps/rails3-devise-rspec-cucumber/master/features/users/sign_up.feature', 'features/users/sign_up.feature'
        get 'https://raw.github.com/RailsApps/rails3-devise-rspec-cucumber/master/features/users/user_edit.feature', 'features/users/user_edit.feature'
        get 'https://raw.github.com/RailsApps/rails3-devise-rspec-cucumber/master/features/users/user_show.feature', 'features/users/user_show.feature'
        get 'https://raw.github.com/RailsApps/rails3-devise-rspec-cucumber/master/features/step_definitions/user_steps.rb', 'features/step_definitions/user_steps.rb'
        remove_file 'features/support/paths.rb'
        get 'https://raw.github.com/RailsApps/rails3-devise-rspec-cucumber/master/features/support/paths.rb', 'features/support/paths.rb'
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
      rescue OpenURI::HTTPError
        say_wizard "Unable to obtain Cucumber example files from the repo"
      end
    end 
  end
end

__END__

name: testing
description: "Add testing framework."
author: RailsApps

category: testing

args: ["-T"]
