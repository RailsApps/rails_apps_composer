# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require File.dirname(__FILE__) + "/version"

Gem::Specification.new do |s|
  s.name        = "rails_apps_composer"
  s.version     = RailsWizard::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Daniel Kehoe"]
  s.email       = ["daniel@danielkehoe.com"]
  s.homepage    = "http://github.com/RailsApps/rails_apps_composer"
  s.summary     = %q{A version of the RailsWizard gem with custom recipes for Rails starter apps.}
  s.description = %q{A gem with recipes to create Rails application templates you can use to generate Rails starter apps.}

  s.rubyforge_project = "rails_apps_composer"
  
  s.add_dependency "i18n"
  s.add_dependency "activesupport", ">= 3.0.0"
  s.add_dependency "thor"
  s.add_dependency "rake"
  s.add_development_dependency "rspec", ">= 2.5.0"
  s.add_development_dependency "mg"
  s.add_development_dependency "activesupport", ">= 3.0.0"
  s.add_development_dependency "i18n"

  s.files         = Dir["lib/**/*.rb", "recipes/*.rb", "README.textile", "version.rb", "templates/*"] 
  s.test_files    = Dir["spec/**/*"] 
  s.executables   = ["rails_apps_composer"]
  s.require_paths = ["lib"]
end

