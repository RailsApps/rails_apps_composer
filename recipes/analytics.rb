# Application template recipe for the rails_apps_composer. Change the recipe here:
# https://github.com/RailsApps/rails_apps_composer/blob/master/recipes/analytics.rb

prefs[:analytics] = multiple_choice "Install page-view analytics?", [["None", "none"],
  ["Google Analytics", "ga"],
  ["Segment.com", "segmentio"]] unless prefs.has_key? :analytics
case prefs[:analytics]
  when 'ga'
    ga_id = ask_wizard('Google Analytics ID?')
  when 'segmentio'
    segmentio_api_key = ask_wizard('Segment.com Write Key?')
end

stage_two do
  say_wizard "recipe stage two"
  unless prefer :analytics, 'none'
    # don't add the gem if it has already been added by the railsapps recipe
    add_gem 'rails_apps_pages', :group => :development unless prefs[:apps4]
  end
  case prefs[:analytics]
    when 'ga'
      generate 'analytics:google -f'
      gsub_file 'app/assets/javascripts/google_analytics.js.coffee', /UA-XXXXXXX-XX/, ga_id
    when 'segmentio'
      generate 'analytics:segmentio -f'
      gsub_file 'app/assets/javascripts/segmentio.js', /SEGMENTIO_API_KEY/, segmentio_api_key
  end
  ### GIT ###
  git :add => '-A' if prefer :git, true
  git :commit => '-qm "rails_apps_composer: add analytics"' if prefer :git, true
end

__END__

name: analytics
description: "Add JavaScript files for Segment.com or Google Analytics"
author: RailsApps

requires: [setup, gems]
run_after: [setup, gems, init]
category: other
