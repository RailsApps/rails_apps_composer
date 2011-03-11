require 'rails_wizard/recipe'

module RailsWizard
  module Recipes
    class Rspec < RailsWizard::Recipe
      key "rspec"
      name "RSpec"
      category "unit_testing"
      description "Use RSpec for unit testing for this Rails app."
    end
  end
end

__END__

gem 'rspec-rails', '>= 2.0.1', :group => [:development, :test]

inject_into_file "config/initializers/generators.rb", :after => "Rails.application.config.generators do |g|\n" do
  "    g.test_framework = :rspec\n"
end

after_bundler do
  generate 'rspec:install'
end
