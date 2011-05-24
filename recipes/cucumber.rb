# Application template recipe for the rails_apps_composer. Check for a newer version here:
# https://github.com/RailsApps/rails_apps_composer/blob/master/recipes/cucumber.rb

if config['cucumber']
  if recipes.include? 'rails 3.0'
    # for Rails 3.0, use only gem versions we know that work
    gem 'cucumber-rails', '0.4.1', :group => :test
    gem 'capybara', '0.4.1.2', :group => :test
    gem 'database_cleaner', '0.6.7', :group => :test
    gem 'launchy', '0.4.0', :group => :test
  else
    # for Rails 3.1+, use optimistic versioning for gems
    gem 'cucumber-rails', '>= 0.5.0', :group => :test
    gem 'capybara', '>= 1.0.0.beta1', :group => :test
    gem 'database_cleaner', '>= 0.6.7', :group => :test
    gem 'launchy', '>= 0.4.0', :group => :test
  end
else
  recipes.delete('cucumber')
end

if config['cucumber']
  after_bundler do
    say_wizard "Cucumber recipe running 'after bundler'"
    generate "cucumber:install --capybara#{' --rspec' if recipes.include?('rspec')}#{' -D' if recipes.include?('mongoid')}"
    if recipes.include? 'mongoid'
      gsub_file 'features/support/env.rb', /transaction/, "truncation"
      inject_into_file 'features/support/env.rb', :after => 'begin' do
        "\n  DatabaseCleaner.orm = 'mongoid'"
      end
    end
  end
end

if config['cucumber']
  if recipes.include? 'devise'
    after_bundler do
      say_wizard "Copying Cucumber scenarios from the rails3-mongoid-devise examples"
      begin
        # copy all the Cucumber scenario files from the rails3-mongoid-devise example app
        get 'https://github.com/RailsApps/rails3-mongoid-devise/raw/master/features/users/sign_in.feature', 'features/users/sign_in.feature'
        get 'https://github.com/RailsApps/rails3-mongoid-devise/raw/master/features/users/sign_out.feature', 'features/users/sign_out.feature'
        get 'https://github.com/RailsApps/rails3-mongoid-devise/raw/master/features/users/sign_up.feature', 'features/users/sign_up.feature'
        get 'https://github.com/RailsApps/rails3-mongoid-devise/raw/master/features/users/user_edit.feature', 'features/users/user_edit.feature'
        get 'https://github.com/RailsApps/rails3-mongoid-devise/raw/master/features/users/user_show.feature', 'features/users/user_show.feature'
        get 'https://github.com/RailsApps/rails3-mongoid-devise/raw/master/features/step_definitions/user_steps.rb', 'features/step_definitions/user_steps.rb'
        remove_file 'features/support/paths.rb'
        get 'https://github.com/RailsApps/rails3-mongoid-devise/raw/master/features/support/paths.rb', 'features/support/paths.rb'
      rescue OpenURI::HTTPError
        say_wizard "Unable to obtain Cucumber example files from the repo"
      end
    end
  end
end

__END__

name: Cucumber
description: "Use Cucumber for BDD (with Capybara)."
author: RailsApps

exclusive: acceptance_testing 
category: testing
tags: [acceptance]

config:
  - cucumber:
      type: boolean
      prompt: Would you like to use Cucumber for your BDD?