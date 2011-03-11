require 'rails_wizard/recipe'

module RailsWizard
  module Recipes
    class Haml < RailsWizard::Recipe
      name "HAML"
      category "templating"
      description "Utilize HAML for templating."
    end
  end
end

__END__

gem 'haml', '>= 3.0.0'
gem 'haml-rails'
