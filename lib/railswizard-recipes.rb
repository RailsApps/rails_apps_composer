require 'rails_wizard/recipe'

Dir[File.dirname(__FILE__) + '/rails_wizard/recipes/**/*.rb'].each{|f| require f}
