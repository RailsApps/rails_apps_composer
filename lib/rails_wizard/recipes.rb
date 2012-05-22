module RailsWizard
  module Recipes
    @@categories = {}
    @@list = {}
    
    def self.add(recipe)
      RailsWizard::Recipes.const_set ActiveSupport::Inflector.camelize(recipe.key), recipe
      @@list[recipe.key] = recipe
      unless recipe.category == 'internal'
        (@@categories[recipe.category.to_s] ||= []) << recipe.key
        @@categories[recipe.category.to_s].uniq!
      end
      recipe
    end

    def self.[](key)
      @@list[key.to_s]
    end

    def self.list
      @@list.keys.sort
    end

    def self.list_classes
      @@list.values.sort_by{|c| c.key}
    end

    def self.categories
      @@categories.keys.sort
    end

    def self.for(category)
      (@@categories[category.to_s] || []).sort
    end

    def self.remove_from_category(category, recipe)
      (@@categories[category.to_s] ||= []).delete(recipe.key)
    end
  end
end
