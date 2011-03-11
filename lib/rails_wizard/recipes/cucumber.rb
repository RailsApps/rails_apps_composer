require 'rails_wizard/recipe'

module RailsWizard
  module Recipes
    class Cucumber < RailsWizard::Recipe
      name "Cucumber"
      category "integration_testing"
      description "Use Cucumber for integration testing with Capybara."
    end
  end
end

__END__

gem 'cucumber-rails', :group => :test
gem 'capybara', :group => :test

after_bundler do
  generate "cucumber:install --capybara#{' --rspec' if recipes.include?('rspec')}#{' -D' unless recipes.include?('activerecord')}"
end
