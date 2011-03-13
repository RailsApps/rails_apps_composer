require 'rails_wizard/recipes'
require 'rails_wizard/recipe'
require 'rails_wizard/config'
require 'rails_wizard/template'

Dir[File.dirname(__FILE__) + '/../recipes/*.rb'].each do |path|
  key = File.basename(path, '.rb')
  recipe = RailsWizard::Recipe.generate(key, File.open(path))
  RailsWizard::Recipes.add(recipe)
end
