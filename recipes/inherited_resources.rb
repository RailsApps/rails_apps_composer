# Application template recipe for the rails_apps_composer. Check for a newer version here:
# https://github.com/gmgp/rails_apps_composer/blob/master/recipes/inherited_resources.rb

if config['inherited_resources']
  gem 'inherited_resources'
else
  recipes.delete('inherited_resources')
end


__END__

name: InheritedResources
description: "Include inherited_resources "
author: Gmgp

category: other
tags: [utilities, configuration]

config:
  - inherited_resources:
      type: boolean
      prompt: Would you like to use 'inherited_resources'?
