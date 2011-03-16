require 'rails_wizard'
require 'thor'

module RailsWizard
  class Command < Thor
    include Thor::Actions
    desc "new APP_NAME", "create a new Rails app"
    method_option :recipes, :type => :array, :aliases => "-r"
    def new(name)
      if options[:recipes]
        run_template(name, options[:recipes])
      else
        @recipes = []

        while recipe = ask("#{print_recipes}#{bold}Which recipe would you like to add? #{clear}#{yellow}(blank to finish)#{clear}")
          if recipe == ''
            run_template(name, @recipes)
          elsif RailsWizard::Recipes.list.include?(recipe)
            @recipes << recipe
            puts
            puts "> #{green}Added '#{recipe}' to template.#{clear}"
          else
            puts
            puts "> #{red}Invalid recipe, please try again.#{clear}"
          end
        end
      end
    end

    desc "list [CATEGORY]", "list available recipes (optionally by category)"
    def list(category = nil)
      if category
        recipes = RailsWizard::Recipes.for(category).map{|r| RailsWizard::Recipe.from_mongo(r) }
      else
        recipes = RailsWizard::Recipes.list_classes
      end

      recipes.each do |recipe|
        puts recipe.key.ljust(15) + "# #{recipe.description}"
      end
    end

    no_tasks do
      def cyan; "\033[36m" end
      def clear; "\033[0m" end
      def bold; "\033[1m" end
      def red; "\033[31m" end
      def green; "\033[32m" end
      def yellow; "\033[33m" end

      def print_recipes
        puts
        puts
        puts
        if @recipes && @recipes.any?
          puts "#{green}#{bold}Your Recipes:#{clear} " + @recipes.join(", ")
          puts
        end
        puts "#{bold}#{cyan}Available Recipes:#{clear} " + RailsWizard::Recipes.list.join(', ')
        puts
      end

      def run_template(name, recipes)
        puts
        puts
        puts "#{bold}Generating and Running Template..."
        puts
        file = Tempfile.new('template')        
        template = RailsWizard::Template.new(recipes)
        file.write template.compile
        file.close
        system "rails new #{name} -m #{file.path} #{template.args.join(' ')}"
      ensure
        file.unlink
      end
    end
  end
end
