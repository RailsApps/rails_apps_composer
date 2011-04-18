# Application template recipe for the rails3_devise_wizard. Check for a newer version here:
# https://github.com/fortuity/rails3_devise_wizard/blob/master/recipes/rspec.rb

if config['rspec']
  say_wizard "A REMINDER: When creating a Rails app using RSpec, you should add the '-T' flag to 'rails new'"
  gem 'rspec-rails', '>= 2.5.0', :group => [:development, :test]
  if recipes.include? 'mongoid'
    # use the database_cleaner gem to reset the test database
    gem 'database_cleaner', '>= 0.6.6', :group => :test
    # include RSpec matchers from the mongoid-rspec gem
    gem 'mongoid-rspec', ">= 1.4.1", :group => :test
  end
  if config['factory_girl']
    # use the factory_girl gem for test fixtures
    gem 'factory_girl_rails', ">= 1.1.beta1", :group => :test
  end
else
  recipes.delete('rspec')
end

# note: there is no need to specify the RSpec generator in the config/application.rb file

if config['rspec']
  after_bundler do
    generate 'rspec:install'

    # remove ActiveRecord artifacts
    gsub_file 'spec/spec_helper.rb', /config.fixture_path/, '# config.fixture_path'
    gsub_file 'spec/spec_helper.rb', /config.use_transactional_fixtures/, '# config.use_transactional_fixtures'

    if recipes.include? 'mongoid'
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
    end
  
    # remove either possible occurrence of "require rails/test_unit/railtie"
    gsub_file 'config/application.rb', /require 'rails\/test_unit\/railtie'/, '# require "rails/test_unit/railtie"'
    gsub_file 'config/application.rb', /require "rails\/test_unit\/railtie"/, '# require "rails/test_unit/railtie"'

    say_wizard "Removing test folder (not needed for RSpec)"
    run 'rm -rf test/'

    if recipes.include? 'mongoid'
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
author: fortuity

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
