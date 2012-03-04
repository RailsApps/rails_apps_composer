# Application template recipe for the rails_apps_composer. Check for a newer version here:
# https://github.com/RailsApps/rails_apps_composer/blob/master/recipes/html5.rb

case config['css_option']
  when 'foundation'
    # https://github.com/zurb/foundation-rails
    gem 'zurb-foundation'
  when 'bootstrap_less'
    # https://github.com/seyhunak/twitter-bootstrap-rails
    # http://railscasts.com/episodes/328-twitter-bootstrap-basics
    gem 'twitter-bootstrap-rails', '~> 2.0.3', :group => :assets
    # for external check
    recipes << 'bootstrap'
  when 'bootstrap_sass'
    # https://github.com/thomas-mcdonald/bootstrap-sass
    # http://rubysource.com/twitter-bootstrap-less-and-sass-understanding-your-options-for-rails-3-1/
    gem 'bootstrap-sass', '~> 2.0.1'
    # for external check
    recipes << 'bootstrap'
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
      insert_into_file "app/assets/stylesheets/application.css", " *= require foundation\n", :after => "require_self\n"

    when 'bootstrap_less'
      say_wizard "installing Twitter Bootstrap HTML5 framework (less) "
      generate 'bootstrap:install'

    when 'bootstrap_sass'
      say_wizard "installing Twitter Bootstrap HTML5 framework (sass) "
      insert_into_file "app/assets/javascripts/application.js", "//= require bootstrap\n", :after => "jquery_ujs\n"
      create_file "app/assets/stylesheets/bootstrap_and_overrides.css.scss", "\n@import 'bootstrap';\n"

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

__END__

name: html5
description: "Install a front-end framework for HTML5 and CSS."
author: RailsApps

category: other
tags: [utilities, configuration]

config:
  - css_option:
      type: multiple_choice
      prompt: "Which front-end framework would you like for HTML5 and CSS?"
      choices: [["None", nothing], ["Zurb Foundation", foundation], ["Twitter Bootstrap (less)", bootstrap_less], ["Twitter Bootstrap (sass)", bootstrap_sass], ["Skeleton", skeleton], ["Just normalize CSS for consistent styling", normalize]]
