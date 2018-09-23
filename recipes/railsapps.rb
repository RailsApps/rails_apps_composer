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
when "5"
  prefs[:apps4] = multiple_choice "Build a starter application?",
    [["Build a RailsApps example application", "railsapps"],
    ["Contributed applications", "contributed_app"],
    ["Custom application (experimental)", "none"]] unless prefs.has_key? :apps4
  case prefs[:apps4]
    when 'railsapps'
        prefs[:apps4] = multiple_choice "Choose a starter application.",
        [["learn-rails", "learn-rails"],
        ["rails-bootstrap", "rails-bootstrap"],
        ["rails-foundation", "rails-foundation"],
        ["rails-mailinglist-activejob", "rails-mailinglist-activejob"],
        ["rails-omniauth", "rails-omniauth"],
        ["rails-devise", "rails-devise"],
        ["rails-devise-roles", "rails-devise-roles"],
        ["rails-devise-pundit", "rails-devise-pundit"],
        ["rails-signup-download", "rails-signup-download"],
        ["rails-stripe-checkout", "rails-stripe-checkout"],
        ["rails-stripe-coupons", "rails-stripe-coupons"]]
    when 'contributed_app'
      prefs[:apps4] = multiple_choice "Choose a starter application.",
        [["rails-shortcut-app", "rails-shortcut-app"],
        ["rails-signup-thankyou", "rails-signup-thankyou"]]
  end
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
        case Rails::VERSION::MINOR.to_s
        when "2"
          prefs[:apps4] = multiple_choice "Choose a starter application.",
          [["learn-rails", "learn-rails"],
          ["rails-bootstrap", "rails-bootstrap"],
          ["rails-foundation", "rails-foundation"],
          ["rails-mailinglist-activejob", "rails-mailinglist-activejob"],
          ["rails-omniauth", "rails-omniauth"],
          ["rails-devise", "rails-devise"],
          ["rails-devise-roles", "rails-devise-roles"],
          ["rails-devise-pundit", "rails-devise-pundit"],
          ["rails-signup-download", "rails-signup-download"],
          ["rails-stripe-checkout", "rails-stripe-checkout"],
          ["rails-stripe-coupons", "rails-stripe-coupons"],
          ["rails-stripe-membership-saas", "rails-stripe-membership-saas"]]
        else
          prefs[:apps4] = multiple_choice "Upgrade to Rails 4.2 for more choices.",
          [["learn-rails", "learn-rails"],
          ["rails-bootstrap", "rails-bootstrap"],
          ["rails-foundation", "rails-foundation"],
          ["rails-omniauth", "rails-omniauth"],
          ["rails-devise", "rails-devise"],
          ["rails-devise-roles", "rails-devise-roles"],
          ["rails-devise-pundit", "rails-devise-pundit"]]
        end
      when 'contributed_app'
        prefs[:apps4] = multiple_choice "No contributed applications are available.",
          [["create custom application", "railsapps"]]
    end
  end
end

unless prefs[:announcements]
  say_loud '', 'Get on the mailing list for Rails Composer news?'
  prefs[:announcements] = ask_wizard('Enter your email address:')
  if prefs[:announcements].present?
    system "curl --silent http://mailinglist.railscomposer.com/api -d'visitor[email]=#{prefs[:announcements]}' > /dev/null"
    prefs[:announcements] = 'mailinglist'
  else
    prefs[:announcements] = 'none'
  end
end

__END__

name: railsapps
description: "Install RailsApps example applications."
author: RailsApps

requires: [core]
run_after: [git]
category: configuration
