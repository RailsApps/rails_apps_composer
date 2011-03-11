require 'rails_wizard/recipe'

module RailsWizard
  module Recipes
    class Slim < RailsWizard::Recipe
      name "Slim"
      category "templating"
      description "Use Slim as the default templating engine."
    end
  end
end

__END__

gem 'slim'
gem 'slim-rails'
