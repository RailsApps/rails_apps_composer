require 'bundler'
Bundler::GemHelper.install_tasks

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
    file = Tempfile.new('temporary_template')
    file.write template.compile
    file.close  
    
    system "rails new test_run -m #{file.path} #{template.args.join(' ')}"
  ensure
    file.unlink
  end
end

desc "Prints out a template from the provided recipes."
task :print do
  require 'rails_wizard'

  recipes = ENV['RECIPES'].split(',')
  puts RailsWizard::Template.new(recipes).compile
end
