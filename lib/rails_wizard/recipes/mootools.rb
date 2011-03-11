require 'rails_wizard/recipe'

module RailsWizard
  module Recipes
    class Mootools < RailsWizard::Recipe
      name "MooTools"
      category "javascript"
      description "Adds MooTools and MooTools-compatible UJS helpers."
    end
  end
end

__END__

inside "public/javascripts" do
  get "https://github.com/kevinvaldek/mootools-ujs/raw/master/Source/rails.js", "rails.js"
  get "http://ajax.googleapis.com/ajax/libs/mootools/1.2.5/mootools-yui-compressed.js", "mootools.min.js"
end

gsub_file "config/application.rb", /# JavaScript.*\n/, ""
gsub_file "config/application.rb", /# config\.action_view\.javascript.*\n/, ""

application do
  "\n    config.action_view.javascript_expansions[:defaults] = %w(mootools.min rails)\n"
end
