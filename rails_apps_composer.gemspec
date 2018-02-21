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
  s.license     = 'MIT'

  s.rubyforge_project = "rails_apps_composer"

  s.add_dependency "i18n", '~> 0.7'
  s.add_dependency "activesupport", '~> 5.1'
  s.add_dependency "thor", '~> 0.20'
  s.add_dependency "rake", '~> 12.3'
  s.add_development_dependency "rspec", '~> 3.7'
  s.add_development_dependency "mg", '0.0.8'

  s.files         = Dir["lib/**/*.rb", "recipes/*.rb", "README.textile", "version.rb", "templates/*"]
  s.test_files    = Dir["spec/**/*"]
  s.executables   = ["rails_apps_composer"]
  s.require_paths = ["lib"]
end
