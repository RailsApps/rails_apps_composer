# Application template recipe for the rails_apps_composer. Change the recipe here:
# https://github.com/RailsApps/rails_apps_composer/blob/master/recipes/tests4.rb

after_bundler do
  say_wizard "recipe running after 'bundle install'"
  ### RSPEC ###
  if prefer :tests, 'rspec'
    say_wizard "recipe installing RSpec"
    run 'rm -rf test/' # Removing test folder (not needed for RSpec)
    generate 'rspec:install'
    inject_into_file '.rspec', "--format documentation\n", :after => "--color\n"
    gsub_file 'spec/spec_helper.rb', /ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)/, "ActiveRecord::Migration.maintain_test_schema!"
    inject_into_file 'config/application.rb', :after => "Rails::Application\n" do <<-RUBY

    config.generators do |g|
      g.test_framework :rspec,
        fixtures: true,
        view_specs: false,
        helper_specs: false,
        routing_specs: false,
        controller_specs: false,
        request_specs: false
      g.fixture_replacement :factory_girl, dir: "spec/factories"
    end

RUBY
    end
    ### Configure Launchy to display CSS and JavaScript
    create_file 'spec/support/capybara.rb', "Capybara.asset_host = 'http://localhost:3000'\n"
    ### Configure Database Cleaner to test JavaScript
    gsub_file 'spec/spec_helper.rb', /config.use_transactional_fixtures = true/, "config.use_transactional_fixtures = false"
    create_file 'spec/support/database_cleaner.rb' do
    <<-RUBY
RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, :js => true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.append_after(:each) do
    DatabaseCleaner.clean
  end
end
RUBY
    end
    ### Configure FactoryGirl for shortcuts
    create_file 'spec/support/factory_girl.rb' do
    <<-RUBY
RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
end
RUBY
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
  ### GUARD
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
  # copy tests from repos here
end # after_everything

__END__

name: tests4
description: "Add testing framework."
author: RailsApps

requires: [setup, gems]
run_after: [setup, gems]
category: testing
