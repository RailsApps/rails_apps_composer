require 'rails_wizard'
require 'thor'

module RailsWizard
  class Command < Thor
    include Thor::Actions
    desc "new APP_NAME", "create a new Rails app"
    method_option :recipes, :type => :array, :aliases => "-r"
    method_option :gems, :type => :array, :aliases => "-g"
    method_option :defaults, :type => :string, :aliases => "-d"
    def new(name)
      recipes, gems, defaults = load_defaults
      recipes, gems = ask_for_recipes(recipes, gems)
      run_template(name, recipes, gems, defaults, nil)
    end

    desc "template TEMPLATE_FILE", "create a new Rails template"
    method_option :recipes, :type => :array, :aliases => "-r"
    method_option :gems, :type => :array, :aliases => "-g"
    method_option :defaults, :type => :string, :aliases => "-d"
    def template(template_name)
      recipes, gems, defaults = load_defaults
      recipes, gems = ask_for_recipes(recipes, gems)
      run_template(nil, recipes, gems, defaults, template_name)
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

      def load_defaults
        # Load defaults from a file; if a file specifies recipes, they'll be run *before*
        # any on the command line (or prompted for)..
        defaults = if options[:defaults]
          File.open(options[:defaults]) {|f| YAML.load(f) }
        else
          {}
        end
        recipes = defaults.delete('recipes') { [] }
        gems = defaults.delete('gems') { [] }
        [recipes, gems, defaults]
      end

      def print_recipes(recipes, gems)
        puts
        puts "#{bold}#{cyan}Available Recipes#{clear}:"
        RailsWizard::Recipes.categories.each do |category|
          puts "#{bold}#{cyan}#{category}#{clear}: " +RailsWizard::Recipes.for(category).collect {|recipe|
            recipes.include?(recipe) ? "#{green}#{bold}#{recipe}#{clear}" : recipe
          }.join(', ')
        end
        unless gems.empty?
          puts "\n#{bold}#{cyan}Additional Gems#{clear}: " +
               gems.map {|gem| "#{green}#{bold}#{gem}#{clear}" }.join(', ')
        end
        puts
      end

      def ask_for_recipes(recipes, gems)
        if options[:recipes] || options[:gems]
          recipes = [recipes + options[:recipes]].flatten if options[:recipes]
          gems = [gems + options[:gems]].flatten if options[:gems]
          return [recipes, gems]
        end
        while recipe = ask("#{print_recipes(recipes, gems)}#{bold}Which recipe or gem would you like to add? #{clear}#{yellow}(blank to finish)#{clear}")
          if recipe == ''
            break
          elsif recipes.include?(recipe)
            recipes -= [recipe]
          elsif RailsWizard::Recipes.list.include?(recipe)
            recipes << recipe
          else
            gems << recipe
          end
        end
        [recipes, gems]
      end

      #pass in name if you want to create a rails app
      #pass in file_name if you want to create a template
      def run_template(name, recipes, gems, defaults, file_name=nil)
        puts
        puts
        puts "#{bold}Generating#{name ? " and Running" : ''} Template..."
        puts

        if file_name
          file = File.new(file_name,'w')
        else
          file = Tempfile.new('template')
        end
        template = RailsWizard::Template.new(recipes, defaults)
        file.write template.compile
        file.close
        if name
          system "rails new #{name} -m #{file.path} #{template.args.join(' ')}"
        else
          puts "install with the command:"
          puts
          puts "rails new <APP_NAME> -m #{file.path} #{template.args.join(' ')}"
        end
      ensure
        file.unlink unless file_name
      end
    end
  end
end
