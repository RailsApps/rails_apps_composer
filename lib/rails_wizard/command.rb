require 'rails_wizard'
require 'thor'

module RailsWizard
  class Command < Thor
    include Thor::Actions
    desc "new APP_NAME", "create a new Rails app"
    method_option :recipes, :type => :array, :aliases => "-r"
    method_option :defaults, :type => :string, :aliases => "-d"
    method_option :recipe_dirs, :type => :array, :aliases => "-l"
    method_option :interactive, :type => :boolean, :aliases => "-i", :default => true
    def new(name)
      add_recipes
      recipes, defaults = load_defaults
      args = ask_for_args(defaults)
      recipes = ask_for_recipes(recipes)
      gems = ask_for_gems(defaults)
      run_template(name, recipes, gems, args, defaults, nil)
    end

    desc "template TEMPLATE_FILE", "create a new Rails template"
    method_option :recipes, :type => :array, :aliases => "-r"
    method_option :defaults, :type => :string, :aliases => "-d"
    method_option :recipe_dirs, :type => :array, :aliases => "-l"
    method_option :interactive, :type => :boolean, :aliases => "-i", :default => true
    def template(template_name)
      add_recipes
      recipes, defaults = load_defaults
      recipes = ask_for_recipes(recipes)
      gems = ask_for_gems(defaults)
      run_template(nil, recipes, gems, nil, defaults, template_name)
    end

    desc "list [CATEGORY]", "list available recipes (optionally by category)"
    def list(category = nil)
      if category
        recipes = RailsWizard::Recipes.for(category).map{|r| RailsWizard::Recipe.from_mongo(r) }
      else
        recipes = RailsWizard::Recipes.list_classes
      end
      puts "#{bold}#{cyan}To learn more about recipes, see#{clear}:"
      puts "#{bold}#{cyan}http://railsapps.github.com/tutorial-rails-apps-composer.html#Recipes#{clear}\n"
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

      def add_recipes
        if dirs = options[:recipe_dirs]
          dirs.each { |d| Recipes.add_from_directory(d) }
        end
      end

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
        elsif !options[:interactive]
          return recipes
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

      def ask_for_gems(defaults)
        gems = defaults["gems"] || []
        if options[:interactive]
          while getgem = ask("#{bold}What gem would you like to add? #{clear}#{yellow}(blank to finish)#{clear}")
            if getgem == ''
              break
            else
              gems << getgem.downcase
            end
          end
        end
        gems
      end

      def ask_for_arg(question, default = nil)
        if default.nil?
          result = nil
          while answer = ask(question)
            case answer.downcase
              when "yes", "y"
                result = true
                break
              when "no", "n"
                result = false
                break
            end
          end
          result
        else
          default
        end
      end
      
      def ask_for_args(defaults)
        args = []
        default_args = defaults["args"] || {}
        
        question = "#{bold}Would you like to skip Test::Unit? (yes for RSpec) \033[33m(y/n)\033[0m#{clear}"
        args << "-T" if ask_for_arg(question, default_args[:skip_test_unit])

        question = "#{bold}Would you like to skip Active Record? (yes for MongoDB) \033[33m(y/n)\033[0m#{clear}"
        args << "-O" if ask_for_arg(question, default_args[:skip_active_record])
        
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
