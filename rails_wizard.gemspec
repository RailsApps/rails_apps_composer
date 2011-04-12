# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require File.dirname(__FILE__) + "/version"

Gem::Specification.new do |s|
  s.name        = "rails_wizard"
  s.version     = RailsWizard::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Michael Bleigh"]
  s.email       = ["michael@intridea.com"]
  s.homepage    = "http://railswizard.org/"
  s.summary     = %q{A tool for quickly generating Rails application templates.}
  s.description = %q{Quickly and easily create Rails application templates featuring dozens of popular libraries.}

  s.rubyforge_project = "rails_wizard"
  
  s.add_dependency "i18n"
  s.add_dependency "activesupport", "~> 3.0.0"
  s.add_dependency "thor"
  s.add_development_dependency "rspec", "~> 2.5.0"
  s.add_development_dependency "mg"
  s.add_development_dependency "activesupport", "~> 3.0.0"
  s.add_development_dependency "i18n"

  s.files         = Dir["lib/**/*.rb", "recipes/*.rb", "README.markdown", "version.rb", "templates/*"] 
  s.test_files    = Dir["spec/**/*"] 
  s.executables   = ["rails_wizard"]
  s.require_paths = ["lib"]
end

