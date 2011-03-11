require 'rails_wizard/recipe'

module RailsWizard
  module Recipes
    class ActiveRecord < RailsWizard::Recipe
      name "ActiveRecord"
      category "orm"
      description "Use the default ActiveRecord database store."
    end
  end
end

__END__

# No additional code required.
