require 'active_support/inflector'

module RailsWizard
  module Recipes
    @@categories = {}
    @@list = {}
    
    def self.add(recipe)
      @@list[recipe.key] = recipe
    end

    def self.list
      @@list.keys.sort
    end

    def self.list_classes
      @@list.values.sort_by{|c| c.key}
    end

    def self.for(category)
      (@@categories[category.to_s] || []).sort
    end

    def self.add_to_category(category, recipe)
      (@@categories[category.to_s] ||= []) << recipe.key
      @@categories[category.to_s].uniq!
    end

    def self.remove_from_category(category, recipe)
      (@@categories[category.to_s] ||= []).delete(recipe.key)
    end
  end

  class Recipe
    def self.inherited(subclass)
      file, = caller[0].partition(':')
      
      parts = File.open(file).read.split(/^__END__$/)
      if parts.size > 1
        subclass.template parts.last.strip
      end
      
      RailsWizard::Recipes.add(subclass)
    end

    # The unique key to reference this recipe, calculated simply
    # as the underscoring of its class name.
    def self.key(val = false)
      ActiveSupport::Inflector.underscore(ActiveSupport::Inflector.demodulize(to_s))
    end

    ATTRIBUTES = %w(category name description template)
    
    ATTRIBUTES.each do |setter|
      class_eval <<-RUBY
        def self.#{setter}(val = false)
          @attributes ||= {}
          @attributes[:#{setter}] = val unless val == false
          @attributes[:#{setter}]
        end

        def #{setter}
          self.class.#{setter}
        end
      RUBY
    end

    def self.category(val = false)
      if @attributes[:category]
        RailsWizard::Recipes.remove_from_category(@attributes[:category], self)
      end

      @attributes ||= {}
      @attributes[:category] = val unless val == false
      RailsWizard::Recipes.add_to_category(val, self)
      @attributes[:category]
    end


    # The attributes hash containing any set values for
    # the properties specified in ATTRIBUTES.
    def self.attributes
      @attributes
    end

    def attributes
      self.class.attributes
    end

    def compile
      "# >#{"[ #{name} ]".center(75,'-')}<\n\n# #{description}\nsay_recipe '#{name}'\n\n#{template}\n"
    end
  end
end
