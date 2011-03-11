require 'rails_wizard/recipe'

module RailsWizard
  module Recipes
    class Mongoid < RailsWizard::Recipe
      name "Mongoid"
      category "orm"
      description "Utilize MongoDB with Mongoid as the ORM."
    end
  end
end

__END__

gem 'mongoid', '>= 2.0.0.beta.19'

after_bundler do
  generate 'mongoid:config'
end
