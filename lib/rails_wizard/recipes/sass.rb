require 'rails_wizard/recipe'

module RailsWizard
  module Recipes
    class Sass < RailsWizard::Recipe
      key "sass"
      name "SASS"
      category "css"
      description "Utilize SASS (through the HAML gem) for really awesome stylesheets!"
    end
  end
end

__END__

unless recipes.include? 'haml'
  gem 'haml', '>= 3.0.0'
end
