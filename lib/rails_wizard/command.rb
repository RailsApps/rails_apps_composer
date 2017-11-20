require 'rails_wizard'
require 'thor'
require 'tempfile'

module RailsWizard
  class Command < Thor
    include Thor::Actions
    desc "new APP_NAME", "create a new Rails app"
    method_option :recipes, :type => :array, :aliases => "-r"
    method_option :defaults, :type => :string, :aliases => "-d"
    method_option :recipe_dirs, :type => :array, :aliases => "-l"
    method_option :no_default_recipes, :type => :boolean, :aliases => "-L"
    method_option :template_root, :type => :string, :aliases => '-t'
    method_option :quiet, :type => :boolean, :aliases => "-q", :default => false
    method_option :verbose, :type => :boolean, :aliases => "-V", :default => false
    def new(name)
      add_recipes
      recipes, defaults = load_defaults
      (print "\ndefaults: "; p defaults) if options[:verbose]
      args = ask_for_args(defaults)
      (print "\nargs: "; p args) if options[:verbose]
      recipes = ask_for_recipes(recipes)
      (print "\nrecipes: "; p recipes) if options[:verbose]
      gems = ask_for_gems(defaults)
      (print "\ngems: "; p gems) if options[:verbose]
      run_template(name, recipes, gems, args, defaults, nil)
    end

    desc "template TEMPLATE_FILE", "create a new Rails template"
    method_option :recipes, :type => :array, :aliases => "-r"
    method_option :defaults, :type => :string, :aliases => "-d"
    method_option :recipe_dirs, :type => :array, :aliases => "-l"
    method_option :no_default_recipes, :type => :boolean, :aliases => "-L"
    method_option :template_root, :type => :string, :aliases => '-t'
    method_option :quiet, :type => :boolean, :aliases => "-q", :default => false
    method_option :verbose, :type => :boolean, :aliases => "-V", :default => false
    def template(template_name)
      add_recipes
      recipes, defaults = load_defaults
      recipes = ask_for_recipes(recipes)
      gems = ask_for_gems(defaults)
      run_template(nil, recipes, gems, nil, defaults, template_name)
    end

    desc "list [CATEGORY]", "list available recipes (optionally by category)"
    def list(category = nil)
      recipes = if category
        RailsWizard::Recipes.for(category).map{|e| RailsWizard::Recipe.from_mongo e}
      else
        RailsWizard::Recipes.list_classes
      end
      address = 'https://github.com/RailsApps/rails_apps_composer/wiki/tutorial-rails-apps-composer#recipes'
      say("To learn more about recipes, see:\n#{address}", [:bold, :cyan])
# https://github.com/wycats/thor/blob/master/lib/thor/shell/basic.rb
      recipes.each{|e| say("#{e.key.ljust 15}# #{e.description}")}
    end

    no_tasks do

      def add_recipes
        Recipes.clear if options[:no_default_recipes]
        if dirs = options[:recipe_dirs]
          dirs.each {|d| Recipes.add_from_directory d}
        end
      end

      def load_defaults
        # Load defaults from a file; if a file specifies recipes, they'll be run *before*
        # any on the command line (or prompted for)..
        return [[], {}] unless options[:defaults]
        defaults = Kernel.open(options[:defaults]) {|f| YAML.load(f) }
        recipes = defaults.delete('recipes') { [] }
        [recipes, defaults]
      end

      def print_recipes(recipes)
        say("\nAvailable Recipes:", [:bold, :cyan])
        RailsWizard::Recipes.categories.each do |category|
          say("#{category} ", [:bold, :cyan])
          a = RailsWizard::Recipes.for(category)
          a.each_with_index do |e,i|
            s = (a.length - 1 == i) ? "#{e}" : "#{e}, "
            if recipes.include?(e)
              say(s, [:bold, :green])
            else
              say(s)
            end
          end
        end
      end

      def ask_for_recipes(recipes)
        return recipes + options[:recipes] if options[:recipes]
        return recipes if options[:quiet]
        loop do
          recipe = prompt_for_recipes(recipes)
          break if '' == recipe
          case
          when recipes.include?(recipe)
            recipes -= [recipe]
          when RailsWizard::Recipes.list.include?(recipe)
            recipes << recipe
          else
            say("\n> Invalid recipe, please try again.", :red)
          end
        end
        recipes
      end

      def prompt_for_recipes(recipes)
        print_recipes(recipes)
        say("\nWhich recipe would you like to add? ", :bold)
        ask('(blank to finish)', :yellow)
      end

      def ask_for_gems(defaults)
        gems = defaults["gems"] || []
        return gems if options[:quiet]
        loop do
          getgem = prompt_for_gems
          break if '' == getgem
          gems << getgem.downcase
        end
        gems
      end

      def prompt_for_gems
        say('What gem would you like to add? ', :bold)
        ask('(blank to finish)', :yellow)
      end

      def ask_for_arg(question, default = nil)
        return default unless default.nil?
        say("#{question} ", :bold)
        result = nil
        loop do
          answer = ask('(y/n)', :yellow)
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
      end

      def ask_for_args(defaults)
        args = []
        default_args = defaults["args"] || {}
        s = 'Would you like to skip'

        question = "#{s} Test::Unit? (yes for RSpec)"
        args << "-T" if ask_for_arg(question, default_args[:skip_test_unit])

        question = "#{s} Active Record? (yes for MongoDB)"
        args << "-O" if ask_for_arg(question, default_args[:skip_active_record])

        args
      end

      def make_red(s)
# http://en.wikipedia.org/wiki/ANSI_escape_code
# http://en.wikibooks.org/wiki/Ruby_Programming/Syntax/Literals#Backslash_Notation
        "\e[31m#{s}\e[0m"
      end

      #pass in name if you want to create a rails app
      #pass in file_name if you want to create a template
      def run_template(name, recipes, gems, args, defaults, file_name=nil)
        if opt = options[:template_root]
          RailsWizard::Template.template_root = opt
        end

        file = if file_name
          File.new(file_name,'w')
        else
          Tempfile.new('template')
        end
        begin
          template = RailsWizard::Template.new(recipes, gems, args, defaults)
          file.write template.compile
          file.close
          if name
            args_list = (args | template.args).join(' ')
            say('Generating basic application, using: ')
            say("\"rails new #{name} -m <temp_file> #{args_list}\"")
            system "rails new #{name} -m #{file.path} #{args_list}"
          else
            say('Generating and saving application template... ')
            say('Done. ')
            say('Generate a new application with the command: ')
            say("\"rails new <APP_NAME> -m #{file.path} #{template.args.join ' '}\"")
          end
        rescue RailsWizard::UnknownRecipeError
          raise Thor::Error.new(make_red("> #{$!.message}."))
        ensure
          file.unlink unless file_name
        end
      end
    end
  end
end
