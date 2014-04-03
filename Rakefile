require 'bundler'
Bundler.setup :development

require 'mg'
MG.new "rails_apps_composer.gemspec"

require 'rspec/core/rake_task'

desc "run specs"
RSpec::Core::RakeTask.new

task :default => :spec


desc "Remove the test_run Rails app (if it's there)"
task :clean do
  system 'rm -rf test_run'
end

desc "Execute a test run with the specified recipes."
task :run => :clean do
  recipes = ENV['RECIPES'].split(',')

  require 'tempfile'
  require 'rails_wizard'

  template = RailsWizard::Template.new(recipes)

  begin
    dir = Dir.mktmpdir "rails_template"
    Dir.chdir(dir) do
      file = File.open('template.rb', 'w')
      file.write template.compile
      file.close

      system "rails new test_run -m template.rb #{template.args.join(' ')}"

      puts "\n\n cd #{dir} # look at the app"
    end
  end
end

namespace :mega do
  require File.expand_path('../megatest/bash_scripts.rb', __FILE__)

# For method 'sh', see http://rake.rubyforge.org/classes/FileUtils.html#M000018

  desc  'Safely clone the Rails Example App repositories'
  task :clone do
    puts '+Safely cloning Rails Example App repositories'
    s = SET_CLONED_DIRECTORY_SCRIPT + CLONE_APP_REPOSITORIES_SCRIPT
    sh(s){|_,result| raise unless result.to_i.zero?}
  end

  task :create_dir_for_generated_apps do
    puts '+Creating the directory to contain generated Rails Example Apps'
    location = '../generated'
    f1 = FileList[location].existing
    raise "Directory '#{location}' must not exist; rename it" unless f1.empty?
    ::Dir.mkdir location
  end

  task :create_repo_list do
    puts '+Creating the list of Rails Example Apps'
    s = SET_GENERATED_DIRECTORY_SCRIPT + CREATE_REPOSITORY_LIST_SCRIPT
    sh(s){|_,result| raise unless result.to_i.zero?}
  end

  desc  'Generate the Rails Example Apps'
  task :generate do
    puts '+Generating Rails Example Apps'
    s = SET_GENERATED_DIRECTORY_SCRIPT + GENERATE_APPS_SCRIPT
    Bundler.with_clean_env do
      sh(s){|_,result| raise unless result.to_i.zero?}
    end
  end

  desc 'Run the megatest, after setup (for internal use)'
  task :test => %w[
      mega:create_dir_for_generated_apps
      mega:create_repo_list
      mega:generate
      mega:generated:migrate
      mega:generated:env_vars
      mega:generated:test
      ] do
    puts "\nCongratulations! Your megatest has successfully completed.\n\n"
  end

  namespace :cloned do
    desc      'Make cloned Rails Example Apps read service-key environment variables'
    task :env_vars do
      puts '+Making cloned Rails Example Apps read service-key environment variables'
      s = SET_CLONED_DIRECTORY_SCRIPT + MAKE_APPS_READ_SERVICE_ENV_VARS_SCRIPT
      sh(s){|_,result| raise unless result.to_i.zero?}
    end

    desc   "Fetch the cloned Rails Example App updates"
    task :fetch do
      puts "+Fetching cloned Rails Example App updates"
      s = SET_CLONED_DIRECTORY_SCRIPT + FETCH_APP_UPDATES_SCRIPT
      sh(s){|_,result| raise unless result.to_i.zero?}
    end

    desc   "Show the cloned Rails Example Apps' git status"
    task :git_status do
      puts "+Showing cloned Rails Example Apps' git status"
      s = SET_CLONED_DIRECTORY_SCRIPT + SHOW_APPS_GIT_STATUS_SCRIPT
      sh(s){|_,result| raise unless result.to_i.zero?}
    end

    desc      'Migrate cloned Rails Example App databases'
    task :migrate do
      puts '+Migrating cloned Rails Example App databases'
      s = SET_CLONED_DIRECTORY_SCRIPT + MIGRATE_APP_DATABASES_SCRIPT
      Bundler.with_clean_env do
        sh(s){|_,result| raise unless result.to_i.zero?}
      end
    end

    desc  "Rebase the cloned Rails Example Apps' updates"
    task :rebase do
      puts "+Rebasing cloned Rails Example Apps' updates"
      s = SET_CLONED_DIRECTORY_SCRIPT + REBASE_APP_UPDATES_SCRIPT
      sh(s){|_,result| raise unless result.to_i.zero?}
    end

    desc   "List the cloned Rails Example Apps' remotes"
    task :remote do
      puts '+Listing cloned Rails Example App remotes'
      s = SET_CLONED_DIRECTORY_SCRIPT + LIST_APP_REMOTES_SCRIPT
      sh(s){|_,result| raise unless result.to_i.zero?}
    end

    desc   'Test the cloned Rails Example Apps'
    task :test do
      puts '+Testing cloned Rails Example Apps'
      s = SET_CLONED_DIRECTORY_SCRIPT + TEST_APPS_SCRIPT
      Bundler.with_clean_env do
        sh(s){|_,result| raise unless result.to_i.zero?}
      end
    end
  end

  namespace :generated do
    desc      'Make generated Rails Example Apps read service-key environment variables'
    task :env_vars do
      puts '+Making generated Rails Example Apps read service-key environment variables'
      s = SET_GENERATED_DIRECTORY_SCRIPT + MAKE_APPS_READ_SERVICE_ENV_VARS_SCRIPT
      sh(s){|_,result| raise unless result.to_i.zero?}
    end

    desc      'Migrate generated Rails Example App databases'
    task :migrate do
      puts '+Migrating generated Rails Example App databases'
      s = SET_GENERATED_DIRECTORY_SCRIPT + MIGRATE_APP_DATABASES_SCRIPT
      Bundler.with_clean_env do
        sh(s){|_,result| raise unless result.to_i.zero?}
      end
    end

    desc   'Test the generated Rails Example Apps'
    task :test do
      puts '+Testing generated Rails Example Apps'
      s = SET_GENERATED_DIRECTORY_SCRIPT + TEST_APPS_SCRIPT
      Bundler.with_clean_env do
        sh(s){|_,result| raise unless result.to_i.zero?}
      end
    end
  end
end

desc 'Run the megatest'
task :megatest do

# In order to use Rails 3, you may need to adjust the "activesupport" line in
# rails_apps_composer.gemspec. Currently, rails_apps_composer seems not to
# support Rails 3.

# "set -e" means "errexit".

  RUN_MEGATEST_SCRIPT = <<BASH
(
set -e
bundle update activesupport
gem uninstall rails_apps_composer -x
bundle exec rake reinstall
rm -rf ../generated
bundle exec rake mega:test --trace
)
BASH
  Bundler.with_clean_env do
    ::Kernel.exec RUN_MEGATEST_SCRIPT # Replace the current process.
  end
end

desc "Prints out a template from the provided recipes."
task :print do
  require 'rails_wizard'

  recipes = ENV['RECIPES'].split(',')
  puts RailsWizard::Template.new(recipes).compile
end

desc "uninstall rails_apps_composer gem and install a new version"
task :reinstall do
  Rake::Task['clobber'].invoke
  Rake::Task['gem'].invoke
  Rake::Task['gem:install'].invoke
  puts "installed new rails_apps_composer #{RailsWizard::VERSION}"
end
