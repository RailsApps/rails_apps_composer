require 'rails_wizard/recipes'
require 'rails_wizard/recipe'
require 'rails_wizard/config'
require 'rails_wizard/diagnostics'
require 'rails_wizard/template'

RailsWizard::Recipes.add_from_directory(File.dirname(__FILE__) + '/../recipes')
