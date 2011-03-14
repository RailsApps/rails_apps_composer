module RailsWizard
  class Template
    attr_reader :recipes

    def initialize(recipes)
      @recipes = recipes.map{|r| RailsWizard::Recipe.from_mongo(r)}
    end

    def self.template_root
      File.dirname(__FILE__) + '/../../templates'
    end

    def self.render(template_name, binding = nil)
      erb = ERB.new(File.open(template_root + '/' + template_name + '.erb').read)
      erb.result(binding)
    end
    def render(template_name, binding = nil); self.class.render(template_name, binding) end


    def resolve_recipes
      recipes_with_dependencies.sort
    end

    def recipes_with_dependencies
      @recipes_with_dependencies ||= recipes
      
      added_more = false
      for recipe in recipes
        recipe.requires.each do |requirement|
          unless @recipes_with_dependencies.include?(requirement)
            @recipes_with_dependencies << requirement
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
