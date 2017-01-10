# Application template recipe for the rails_apps_composer. Change the recipe here:
# https://github.com/RailsApps/rails_apps_composer/blob/master/recipes/railsapps.rb

raise if (defined? defaults) || (defined? preferences) # Shouldn't happen.
if options[:verbose]
  print "\nrecipes: ";p recipes
  print "\ngems: "   ;p gems
  print "\nprefs: "  ;p prefs
  print "\nconfig: " ;p config
end

if (Rails::VERSION::MAJOR < 4 ||  (Rails::VERSION::MAJOR == 4 && Rails::VERSION::MINOR == 0))
  say_wizard "Please upgrade to Rails 4.1 or newer."
else
  prefs[:apps4] = multiple_choice "Build a starter application?",
    [["Build datarockets application", "railsapps"],
    ["Custom application (experimental)", "none"]] unless prefs.has_key? :apps4
  if prefs[:apps4] == 'railsapps'
    prefs[:apps4] = multiple_choice "Choose a starter application.",
        [["rails-datarockets-api", "rails-datarockets-api"]]
  end
end


__END__

name: railsapps
description: "Install RailsApps example applications."
author: RailsApps

requires: [core]
run_after: [git]
category: configuration
