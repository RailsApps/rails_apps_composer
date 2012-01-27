# Application template recipe for the rails_apps_composer. Check for a newer version here:
# https://github.com/RailsApps/rails_apps_composer/blob/master/recipes/html5.rb

if recipes.include? 'rails 3.1' or recipies.include? 'rails 3.2'
  case config['css_option']
    when 'foundation'
      # https://github.com/zurb/foundation-rails
      gem 'zurb-foundation'
    when 'bootstrap'
      # https://github.com/thomas-mcdonald/bootstrap-sass
      # http://rubysource.com/twitter-bootstrap-less-and-sass-understanding-your-options-for-rails-3-1/
      gem 'bootstrap-sass'
  end
  after_bundler do
    say_wizard "HTML5 recipe running 'after bundler'"
    # add a humans.txt file
    get "https://raw.github.com/RailsApps/rails3-application-templates/master/files/humans.txt", "public/humans.txt"
    # install a front-end framework for HTML5 and CSS3
    case config['css_option']
      when 'nothing'
        say_wizard "no HTML5 front-end framework selected"
      when 'foundation'
        say_wizard "installing Zurb Foundation HTML5 framework"
        insert_into_file "app/assets/javascripts/application.js", "//= require foundation\n", :after => "jquery_ujs\n"
        insert_into_file "app/assets/stylesheets/application.css.scss", " *= require foundation\n", :after => "require_self\n"
      when 'bootstrap'
        say_wizard "installing Twitter Bootstrap HTML5 framework"
        insert_into_file "app/assets/javascripts/application.js", "//= require bootstrap\n", :after => "jquery_ujs\n"
        insert_into_file "app/assets/stylesheets/application.css.scss", " *= require bootstrap\n", :after => "require_self\n"
      when 'skeleton'
        say_wizard "installing Skeleton HTML5 framework"
        get "https://raw.github.com/necolas/normalize.css/master/normalize.css", "app/assets/stylesheets/normalize.css.scss"
        get "https://raw.github.com/dhgamache/Skeleton/master/stylesheets/base.css", "app/assets/stylesheets/base.css.scss"
        get "https://raw.github.com/dhgamache/Skeleton/master/stylesheets/layout.css", "app/assets/stylesheets/layout.css.scss"
        get "https://raw.github.com/dhgamache/Skeleton/master/stylesheets/skeleton.css", "app/assets/stylesheets/skeleton.css.scss"
        get "https://raw.github.com/dhgamache/Skeleton/master/javascripts/tabs.js", "app/assets/javascripts/tabs.js"
      when 'normalize'
        say_wizard "normalizing CSS for consistent styling"
        get "https://raw.github.com/necolas/normalize.css/master/normalize.css", "app/assets/stylesheets/normalize.css.scss"
    end
    # Set up the default application layout
    if recipes.include? 'haml'
      # Haml version of default application layout
      remove_file 'app/views/layouts/application.html.erb'
      remove_file 'app/views/layouts/application.html.haml'
      get "https://raw.github.com/RailsApps/rails3-application-templates/master/files/views/layouts/application.html.haml", "app/views/layouts/application.html.haml"
      gsub_file "app/views/layouts/application.html.haml", /App_Name/, "#{app_name.humanize.titleize}"
    else
      # ERB version of default application layout
      remove_file 'app/views/layouts/application.html.erb'
      remove_file 'app/views/layouts/application.html.haml'
      get "https://raw.github.com/RailsApps/rails3-application-templates/master/files/views/layouts/application.html.erb", "app/views/layouts/application.html.erb"
      gsub_file "app/views/layouts/application.html.erb", /App_Name/, "#{app_name.humanize.titleize}"
    end
  end
elsif recipes.include? 'rails 3.0'
  say_wizard "Not supported for Rails version #{Rails::VERSION::STRING}. HTML5 recipe skipped."
else
  say_wizard "Don't know what to do for Rails version #{Rails::VERSION::STRING}. HTML5 recipe skipped."
end


__END__

name: html5
description: "Install a front-end framework for HTML5 and CSS3."
author: RailsApps

category: other
tags: [utilities, configuration]

config:
  - css_option:
      type: multiple_choice
      prompt: "Which front-end framework would you like for HTML5 and CSS3?"
      choices: [["None", nothing], ["Zurb Foundation", foundation], ["Twitter Bootstrap", bootstrap], ["Skeleton", skeleton], ["Just normalize CSS for consistent styling", normalize]]

