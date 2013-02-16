module RailsWizard
  class Template
    attr_reader :recipes, :gems, :args, :defaults

    def initialize(recipes, gems=[], args=[], defaults={})
      @recipes = recipes.map{|r| RailsWizard::Recipe.from_mongo(r)}
      @args = args
      @defaults = defaults
      unless defaults['prefs'].nil?
        @prefs = defaults['prefs']
      else
        @prefs = {}
      end
      unless defaults['gems'].nil?
        @gems = gems | defaults['gems']
      else
        @gems = gems
      end
    end

    def self.template_root
      @template_root ||= File.dirname(__FILE__) + '/../../templates'
    end

    def self.template_root=(root)
      @template_root = root
    end

    def self.render(template_name, binding = nil)
      erb = ERB.new(File.open(template_root + '/' + template_name + '.erb').read)
      erb.result(binding)
    end
    def render(template_name, binding = nil); self.class.render(template_name, binding) end

    def resolve_preferences
      @resolve_preferences ||= begin
        @prefs.inspect
      end
    end

    def resolve_gems
      @resolve_gems ||= begin
        @gems.uniq.inspect
      end
    end

    def resolve_diagnostics_recipes
      @resolve_diagnostics_recipes ||= begin
        RailsWizard::Diagnostics.recipes.inspect
      end
    end

    def resolve_diagnostics_prefs
      @resolve_diagnostics_prefs ||= begin
        RailsWizard::Diagnostics.prefs.inspect
      end
    end

    # Sort the recipes list taking 'run_after' directives into account.
    def resolve_recipes
      @resolve_recipes ||= begin
        list = recipes_with_dependencies

        for i in 0...list.size
          after_keys = list[i+1..-1].map { |r| r.key }

          if (list[i].run_after & after_keys).any?
            list.push list.slice!(i)
            redo
          end
        end

        list.each {|recipe| recipe.defaults = defaults[recipe.key] }
        list
      end
    end

    def recipe_classes
      @recipe_classes ||= recipes.map{|r| RailsWizard::Recipe.from_mongo(r)}
    end

    def recipes_with_dependencies
      @recipes_with_dependencies ||= recipe_classes

      added_more = false
      for recipe in recipe_classes
        recipe.requires.each do |requirement|
          requirement = RailsWizard::Recipe.from_mongo(requirement)
          count = @recipes_with_dependencies.size
          (@recipes_with_dependencies << requirement).uniq!
          unless @recipes_with_dependencies.size == count
            added_more = true
          end
        end
      end

      added_more ? recipes_with_dependencies : @recipes_with_dependencies
    end

    def compile
      render 'layout', binding
    end

    def args
      recipes.map(&:args).uniq
    end

    def custom_code?; false end
    def custom_code; nil end
  end
end
