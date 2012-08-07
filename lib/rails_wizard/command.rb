require 'rails_wizard'
require 'thor'

module RailsWizard
  class Command < Thor
    include Thor::Actions
    desc "new APP_NAME", "create a new Rails app"
    method_option :recipes, :type => :array, :aliases => "-r"
    method_option :defaults, :type => :string, :aliases => "-d"
    def new(name)
      args = ask_for_args
      recipes, defaults = load_defaults
      recipes = ask_for_recipes(recipes)
      gems = ask_for_gems
      run_template(name, recipes, gems, args, defaults, nil)
    end

    desc "template TEMPLATE_FILE", "create a new Rails template"
    method_option :recipes, :type => :array, :aliases => "-r"
    method_option :defaults, :type => :string, :aliases => "-d"
    def template(template_name)
      recipes, defaults = load_defaults
      recipes = ask_for_recipes(recipes)
      gems = ask_for_gems
      run_template(nil, recipes, gems, nil, defaults, template_name)
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
        [recipes, defaults]
      end

      def print_recipes(recipes)
        puts
        puts "#{bold}#{cyan}Available Recipes#{clear}:"
        RailsWizard::Recipes.categories.each do |category|
          puts "#{bold}#{cyan}#{category}#{clear}: " +RailsWizard::Recipes.for(category).collect {|recipe|
            recipes.include?(recipe) ? "#{green}#{bold}#{recipe}#{clear}" : recipe
          }.join(', ')
        end
        puts
      end

      def ask_for_recipes(recipes)
        if options[:recipes]
          return recipes + options[:recipes]
        end
        while recipe = ask("#{print_recipes(recipes)}#{bold}Which recipe would you like to add? #{clear}#{yellow}(blank to finish)#{clear}")
          if recipe == ''
            break
          elsif recipes.include?(recipe)
            recipes -= [recipe]
          elsif RailsWizard::Recipes.list.include?(recipe)
            recipes << recipe
          else
            puts
            puts "> #{red}Invalid recipe, please try again.#{clear}"
          end
        end
        recipes
      end

      def ask_for_gems
        gems = []
        while getgem = ask("#{bold}What gem would you like to add? #{clear}#{yellow}(blank to finish)#{clear}")
          if getgem == ''
            break
          else
            gems << getgem.downcase
          end
        end
        gems
      end

      def ask_for_args
        args = []
        question = "#{bold}Would you like to skip Test::Unit? (yes for RSpec) \033[33m(y/n)\033[0m#{clear}"
        while getT = ask(question)
          case getT.downcase
            when "yes", "y"
              args << "-T"
              break
            when "no", "n"
              args << ""
              break
          end
        end
        question = "#{bold}Would you like to skip Active Record? (yes for NoSQL) \033[33m(y/n)\033[0m#{clear}"
        while getO = ask(question)
          case getO.downcase
            when "yes", "y"
              args << "-O"
              break
            when "no", "n"
              args << ""
              break
          end
        end
        args
      end
      
      #pass in name if you want to create a rails app
      #pass in file_name if you want to create a template
      def run_template(name, recipes, gems, args, defaults, file_name=nil)
        if file_name
          file = File.new(file_name,'w')
        else
          file = Tempfile.new('template')
        end
        begin
          template = RailsWizard::Template.new(recipes, gems, args, defaults)
          file.write template.compile
          file.close
          if name
            args_list = (args | template.args).join(' ')
            puts "Generating basic application, using:"
            puts "\"rails new #{name} -m <temp_file> #{args_list}\""
            system "rails new #{name} -m #{file.path} #{args_list}"
          else
            puts "Generating and saving application template..."
            puts "Done."
            puts "Generate a new application with the command:"
            puts "\"rails new <APP_NAME> -m #{file.path} #{template.args.join(' ')}\""
          end
        rescue RailsWizard::UnknownRecipeError
          raise Thor::Error.new("> #{red}#{$!.message}.#{clear}")
        ensure
          file.unlink unless file_name
        end
      end
    end
  end
end
