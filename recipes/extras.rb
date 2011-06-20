# Application template recipe for the rails_apps_composer. Check for a newer version here:
# https://github.com/RailsApps/rails_apps_composer/blob/master/recipes/extras.rb

if config['footnotes']
  say_wizard "Extras recipe running 'after bundler'"
  gem 'rails-footnotes', '>= 3.7', :group => :development
else
  recipes.delete('footnotes')
end

__END__

name: Extras
description: "Various extras including 'rails-footnotes' for development."
author: RailsApps

category: other
tags: [utilities, configuration]

config:
  - footnotes:
      type: boolean
      prompt: Would you like to use 'rails-footnotes' during development?
