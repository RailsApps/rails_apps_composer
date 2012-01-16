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

desc "Prints out a template from the provided recipes."
task :print do
  require 'rails_wizard'

#   recipes = ENV['RECIPES'].split(',')
    # do rspec first; it sets up the generators configuration.
  recipes = %w{
rspec
action_mailer
activerecord
application_layout
capybara
cleanup
compass
css_setup
git
guard
haml
heroku
html5
navigation
sass
static_page
}
  puts RailsWizard::Template.new(recipes).compile
end
