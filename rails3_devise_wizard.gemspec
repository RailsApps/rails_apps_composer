# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require File.dirname(__FILE__) + "/version"

Gem::Specification.new do |s|
  s.name        = "rails3_devise_wizard"
  s.version     = RailsWizard::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Daniel Kehoe"]
  s.email       = ["daniel@danielkehoe.com"]
  s.homepage    = "http://github.com/fortuity/rails3_devise_wizard"
  s.summary     = %q{A gem that creates ready-to-run Rails web applications you can deploy in minutes.}
  s.description = %q{Quickly generate Rails application templates you can use to create and deploy Rails starter apps.}

  s.rubyforge_project = "rails3_devise_wizard"
  
  s.add_dependency "i18n"
  s.add_dependency "activesupport", "~> 3.0.0"
  s.add_dependency "thor"
  s.add_development_dependency "rspec", "~> 2.5.0"
  s.add_development_dependency "mg"
  s.add_development_dependency "activesupport", "~> 3.0.0"
  s.add_development_dependency "i18n"

  s.files         = Dir["lib/**/*.rb", "recipes/*.rb", "README.markdown", "version.rb", "templates/*"] 
  s.test_files    = Dir["spec/**/*"] 
  s.executables   = ["rails3_devise_wizard"]
  s.require_paths = ["lib"]
end

