# Application template recipe for the rails_apps_composer. Check for a newer version here:
# https://github.com/RailsApps/rails_apps_composer/blob/master/recipes/rspec.rb

if config['rspec']
  gem 'rspec-rails', '>= 2.10.1', :group => [:development, :test]
  if recipes.include? 'mongoid'
    # use the database_cleaner gem to reset the test database
    gem 'database_cleaner', '>= 0.7.2', :group => :test
    # include RSpec matchers from the mongoid-rspec gem
    gem 'mongoid-rspec', '>= 1.4.4', :group => :test
  end
  if config['machinist']
    gem 'machinist', :group => :test
  end
  if config['factory_girl']
    gem 'factory_girl_rails', '>= 3.3.0', :group => [:development, :test]
  end
  # add a collection of RSpec matchers and Cucumber steps to make testing email easy
  gem 'email_spec', '>= 1.2.1', :group => :test
  create_file 'features/support/email_spec.rb' do <<-RUBY
require 'email_spec/cucumber'
RUBY
  end
else
  recipes.delete('rspec')
end

# note: there is no need to specify the RSpec generator in the config/application.rb file

if config['rspec']
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
    if config['machinist']
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
      #{"g.fixture_replacement :machinist" if config['machinist']}
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

__END__

name: RSpec
description: "Use RSpec instead of TestUnit."
author: RailsApps

exclusive: unit_testing
category: testing

args: ["-T"]

config:
  - rspec:
      type: boolean
      prompt: Would you like to use RSpec instead of TestUnit?
  - factory_girl:
      type: boolean
      prompt: Would you like to use factory_girl for test fixtures with RSpec?
  - machinist:
      type: boolean
      prompt: Would you like to use machinist for test fixtures with RSpec?
