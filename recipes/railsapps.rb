# Application template recipe for the rails_apps_composer. Change the recipe here:
# https://github.com/RailsApps/rails_apps_composer/blob/master/recipes/railsapps.rb

raise if (defined? defaults) || (defined? preferences) # Shouldn't happen.
if options[:verbose]
  print "\nrecipes: ";p recipes
  print "\ngems: "   ;p gems
  print "\nprefs: "  ;p prefs
  print "\nconfig: " ;p config
end

case Rails::VERSION::MAJOR.to_s
when "3"
  say_wizard "Please upgrade to Rails 4.1 or newer."
when "4"
  case Rails::VERSION::MINOR.to_s
  when "0"
    say_wizard "Please upgrade to Rails 4.1 or newer."
  else
    prefs[:apps4] = multiple_choice "Build a starter application?",
      [["Build a RailsApps example application", "railsapps"],
      ["Contributed applications (none available)", "contributed_app"],
      ["Custom application (experimental)", "none"]] unless prefs.has_key? :apps4
    case prefs[:apps4]
      when 'railsapps'
        prefs[:apps4] = prefs[:rails_4_1_starter_app] || (multiple_choice "Starter apps for Rails 4.1. More to come.",
        [["learn-rails", "learn-rails"],
        ["rails-bootstrap", "rails-bootstrap"],
        ["rails-foundation", "rails-foundation"],
        ["rails-mailinglist-signup", "rails-mailinglist-signup"],
        ["rails-omniauth", "rails-omniauth"],
        ["rails-devise", "rails-devise"],
        ["rails-devise-pundit", "rails-devise-pundit"],
        ["rails-signup-download", "rails-signup-download"]])
      when 'contributed_app'
        prefs[:apps4] = multiple_choice "No contributed applications are available.",
          [["create custom application", "railsapps"]]
    end
  end
end

__END__

name: railsapps
description: "Install RailsApps example applications."
author: RailsApps

requires: [core]
run_after: [git]
category: configuration
