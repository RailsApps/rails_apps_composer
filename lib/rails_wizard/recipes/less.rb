require 'rails_wizard/recipe'

module RailsWizard
  module Recipes
    class Less < RailsWizard::Recipe
      name "Less CSS"
      category "css"
      description "Utilize Less CSS for CSS generation utilizing the \"more\" plugin for Rails."
    end
  end
end

__END__

gem 'less'
plugin 'more', :git => 'git://github.com/cloudhead/more.git'
