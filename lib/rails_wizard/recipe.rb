require 'rails_wizard/config'

require 'active_support/inflector'
require 'yaml'
require 'erb'

module RailsWizard
  class Recipe
    extend Comparable
    
    def self.<=>(another)
      return -1 if another.run_after.include?(self)
      return 1 if another.run_before.include?(self)
      0
    end

    ATTRIBUTES = %w(key args category name description template config exclusive tags run_before run_after requires)
    DEFAULT_ATTRIBUTES = {
      :category => 'other',
      :args => [],
      :tags => [],
      :run_after => [],
      :run_before => [],
      :requires => []
    }

    def self.generate(key, template_or_file, attributes = {})
      if template_or_file.respond_to?(:read)
        file = template_or_file.read
        parts = file.split(/^__END__$/)
        raise ArgumentError, "The recipe file must have YAML matter after an __END__" unless parts.size == 2
        template = parts.first.strip
        attributes = YAML.load(parts.last).inject({}) do |h,(k,v)|
          h[k.to_sym] = v
          h
        end.merge!(attributes)
      else
        template = template_or_file
      end
 
      recipe_class = Class.new(RailsWizard::Recipe) 
      recipe_class.attributes = attributes
      recipe_class.template = template
      recipe_class.key = key

      recipe_class
    end

    ATTRIBUTES.each do |setter|
      class_eval <<-RUBY
        def self.#{setter}
          attributes[:#{setter}]
        end

        def self.#{setter}=(val)
          attributes[:#{setter}] = val
        end

        def #{setter}
          self.class.#{setter}
        end
      RUBY
    end

    # The attributes hash containing any set values for
    def self.attributes
      @attributes ||= DEFAULT_ATTRIBUTES.dup
    end

    def self.attributes=(hash)
      attributes.merge! hash
    end

    def self.config
      return nil unless attributes[:config]
      RailsWizard::Config.new(attributes[:config])
    end

    def attributes
      self.class.attributes
    end

    def self.compile
      "# >#{"[ #{name} ]".center(75,'-')}<\n\n# #{description}\nsay_recipe '#{name}'\n\n#{template}\n"
    end
    def compile; self.class.compile end

    def self.to_mongo(value)
      case value
        when Class
          value.key
        when String
          value
      end
    end

    def self.from_mongo(key)
      return key if key.respond_to?(:superclass) && key.superclass == RailsWizard::Recipe
      RailsWizard::Recipes[key]
    end

    def self.get_binding
      binding
    end
  end
end
