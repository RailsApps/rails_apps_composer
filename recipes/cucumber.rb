# Application template recipe for the rails_apps_composer. Check for a newer version here:
# https://github.com/RailsApps/rails_apps_composer/blob/master/recipes/cucumber.rb

if config['cucumber']
  gem 'cucumber-rails', '>= 1.3.0', :group => :test, :require => false
  gem 'capybara', '>= 1.1.2', :group => :test
  gem 'database_cleaner', '>= 0.7.2', :group => :test
  gem 'launchy', '>= 2.1.0', :group => :test
else
  recipes.delete('cucumber')
end

if config['cucumber']
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

if config['cucumber']
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