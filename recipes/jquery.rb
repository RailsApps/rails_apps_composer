# Application template recipe for the rails_apps_composer. Check for a newer version here:
# https://github.com/RailsApps/rails_apps_composer/blob/master/recipes/jquery.rb

if config['jquery']
  if recipes.include? 'rails 3.0'
    say_wizard "Replacing Prototype framework with jQuery for Rails 3.0."
    after_bundler do
      say_wizard "jQuery recipe running 'after bundler'"
      # remove the Prototype adapter file
      remove_file 'public/javascripts/rails.js'
      # remove the Prototype files (if they exist)
      remove_file 'public/javascripts/controls.js'
      remove_file 'public/javascripts/dragdrop.js'
      remove_file 'public/javascripts/effects.js'
      remove_file 'public/javascripts/prototype.js'
      # add jQuery files
      inside "public/javascripts" do
        get "https://github.com/rails/jquery-ujs/raw/master/src/rails.js", "rails.js"
        get "http://code.jquery.com/jquery-1.6.min.js", "jquery.js"
        if config['ui']
          get "https://ajax.googleapis.com/ajax/libs/jqueryui/1.8.12/jquery-ui.min.js", "jqueryui.js"
        end
      end
      # adjust the Javascript defaults
      # first uncomment "config.action_view.javascript_expansions"
      gsub_file "config/application.rb", /# config.action_view.javascript_expansions/, "config.action_view.javascript_expansions"
      # then add "jquery rails" if necessary
      gsub_file "config/application.rb", /= \%w\(\)/, "%w(jquery rails)"
      # finally change to "jquery jqueryui rails" if necessary
      if config['ui']
        gsub_file "config/application.rb", /jquery rails/, "jquery jqueryui rails"
      end
    end
  elsif recipes.include? 'rails 3.1'
    if config['ui']
      inside "app/assets/javascripts" do
        get "https://ajax.googleapis.com/ajax/libs/jqueryui/1.8.12/jquery-ui.min.js", "jqueryui.js"
      end
    else
      say_wizard "jQuery installed by default in Rails 3.1."
    end
  else
    say_wizard "Don't know what to do for Rails version #{Rails::VERSION::STRING}. jQuery recipe skipped."
  end
else
  if config['ui']
    say_wizard "You said you didn't want jQuery. Can't install jQuery UI without jQuery."
  end
  recipes.delete('jquery')
end

__END__

name: jQuery
description: "Install jQuery (with jQuery UI option) for Rails 3.0 or 3.1."
author: RailsApps

exclusive: javascript_framework
category: assets
tags: [javascript, framework]

args: ["-J"]

config:
  - jquery:
      type: boolean
      prompt: Would you like to use jQuery?
  - ui:
      type: boolean
      prompt: Would you like to use jQuery UI?
