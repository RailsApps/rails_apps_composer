# Application template recipe for the rails3_devise_wizard. Check for a newer version here:
# https://github.com/fortuity/rails3_devise_wizard/blob/master/recipes/cucumber.rb

if config['cucumber']
  gem 'cucumber-rails', ">= 0.4.1", :group => :test
  gem 'capybara', ">= 1.0.0.beta1", :group => :test
  gem 'database_cleaner', '>= 0.6.7', :group => :test
  gem 'launchy', ">= 0.4.0", :group => :test
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
      # copy all the Cucumber scenario files from the rails3-mongoid-devise example app
      inside 'features/users' do
        get 'https://github.com/fortuity/rails3-mongoid-devise/raw/master/features/users/sign_in.feature', 'sign_in.feature'
        get 'https://github.com/fortuity/rails3-mongoid-devise/raw/master/features/users/sign_out.feature', 'sign_out.feature'
        get 'https://github.com/fortuity/rails3-mongoid-devise/raw/master/features/users/sign_up.feature', 'sign_up.feature'
        get 'https://github.com/fortuity/rails3-mongoid-devise/raw/master/features/users/user_edit.feature', 'user_edit.feature'
        get 'https://github.com/fortuity/rails3-mongoid-devise/raw/master/features/users/user_show.feature', 'user_show.feature'
      end
      inside 'features/step_definitions' do
        get 'https://github.com/fortuity/rails3-mongoid-devise/raw/master/features/step_definitions/user_steps.rb', 'user_steps.rb'
      end
      remove_file 'features/support/paths.rb'
      inside 'features/support' do
        get 'https://github.com/fortuity/rails3-mongoid-devise/raw/master/features/support/paths.rb', 'paths.rb'
      end
    end
  end
end

__END__

name: Cucumber
description: "Use Cucumber for BDD (with Capybara)."
author: fortuity

exclusive: acceptance_testing 
category: testing
tags: [acceptance]

config:
  - cucumber:
      type: boolean
      prompt: Would you like to use Cucumber for your BDD?