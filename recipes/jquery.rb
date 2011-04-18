# Application template recipe for the rails3_devise_wizard. Check for a newer version here:
# https://github.com/fortuity/rails3_devise_wizard/blob/master/recipes/jquery.rb

if config['jquery']
  say_wizard "REMINDER: When creating a Rails app using jQuery..."
  say_wizard "you should add the '-J' flag to 'rails new'"
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
      get "https://ajax.googleapis.com/ajax/libs/jquery/1.5.2/jquery.min.js", "jquery.js"
      if config['ui']
        get "https://ajax.googleapis.com/ajax/libs/jqueryui/1.8.11/jquery-ui.min.js", "jqueryui.js"
      end
    end
    # adjust the Javascript defaults
    if config['ui']
      inject_into_file 'config/application.rb', "config.action_view.javascript_expansions[:defaults] = %w(jquery jqueryui rails)\n", :after => "config.action_view.javascript_expansions[:defaults] = %w()\n", :verbose => false
    else
      inject_into_file 'config/application.rb', "config.action_view.javascript_expansions[:defaults] = %w(jquery rails)\n", :after => "config.action_view.javascript_expansions[:defaults] = %w()\n", :verbose => false
    end  
    gsub_file "config/application.rb", /config.action_view.javascript_expansions\[:defaults\] = \%w\(\)\n/, ""
  end
else
  recipes.delete('jquery')
end

__END__

name: jQuery
description: "Use jQuery instead of Prototype."
author: fortuity

exclusive: javascript_framework
category: assets
tags: [javascript, framework]

args: ["-J"]

config:
  - jquery:
      type: boolean
      prompt: Would you like to use jQuery instead of Prototype?
  - ui:
      type: boolean
      prompt: Would you like to use jQuery UI?
