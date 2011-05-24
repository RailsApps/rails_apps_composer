# Application template recipe for the rails_apps_composer. Check for a newer version here:
# https://github.com/RailsApps/rails_apps_composer/blob/master/recipes/rake_fix.rb

if config['rakefix']
  if recipes.include? 'rails 3.0'
    # for Rails 3.0, bind rake gem at version 0.8.7
    gem 'rake', '0.8.7'
  end
else
  recipes.delete('rakefix')
end

__END__

name: RakeFix
description: "For Rails 3.0, bind rake gem at version 0.8.7."
author: RailsApps

category: other
tags: [utilities, configuration]

config:
  - rakefix:
      type: boolean
      prompt: Would you like to use Rake gem version 0.8.7 (recommended)?