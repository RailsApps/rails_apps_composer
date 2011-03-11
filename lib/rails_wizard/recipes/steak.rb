require 'rails_wizard/recipe'

module RailsWizard
  module Recipes
    class Steak < RailsWizard::Recipe
      name "Steak"
      category "integration_testing"
      description "Use Steak and Capybara for integration testing."
    end
  end
end

__END__

gem 'steak', '>= 1.0.0.rc.1'
gem 'capybara'

after_bundler do
  generate 'steak:install'
end
