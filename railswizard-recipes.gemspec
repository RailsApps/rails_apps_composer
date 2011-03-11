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
  s.summary     = %q{The collection of recipes available on RailsWizard.org}
  s.description = %q{The collection of recipes available on RailsWizard.org}

  s.rubyforge_project = "rails_wizard"
  
  s.add_dependency "i18n"
  s.add_dependency "activesupport", "~> 3.0.0"
  s.add_development_dependency "rspec", "~> 2.5.0"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end

