require 'active_support/inflector'
require 'yaml'

module RailsWizard
  class Recipe
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

    ATTRIBUTES = %w(key category name description template)
    
    ATTRIBUTES.each do |setter|
      class_eval <<-RUBY
        def self.#{setter}
          (@attributes ||= {})[:#{setter}]
        end

        def self.#{setter}=(val)
          (@attributes ||= {})[:#{setter}] = val
        end

        def #{setter}
          self.class.#{setter}
        end
      RUBY
    end

    # The attributes hash containing any set values for
    # the properties specified in ATTRIBUTES.
    def self.attributes
      @attributes || {}
    end

    def self.attributes=(hash)
      @attributes = hash
    end

    def attributes
      self.class.attributes
    end

    def compile
      "# >#{"[ #{name} ]".center(75,'-')}<\n\n# #{description}\nsay_recipe '#{name}'\n\n#{template}\n"
    end
  end
end
