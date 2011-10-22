# Application template recipe for the rails_apps_composer. Check for a newer version here:
# https://github.com/RailsApps/rails_apps_composer/blob/master/recipes/html5.rb

if recipes.include? 'rails 3.1'
  gem 'frontend-helpers'
  case config['css_option']
    when 'foundation'
      # https://github.com/zurb/foundation-rails
      gem 'zurb-foundation'
    when 'bootstrap'
      # https://github.com/seyhunak/twitter-bootstrap-rails
      gem 'twitter-bootstrap-rails'
  end
  after_bundler do
    say_wizard "HTML5 recipe running 'after bundler'"
    case config['css_option']
      when 'nothing'
        say_wizard "no HTML5 design framework selected"
      when 'foundation'
        say_wizard "installing Zurb Foundation HTML5 design framework"
        insert_into_file "app/assets/javascripts/application.js", "//= require foundation\n", :after => "jquery_ujs\n"
        insert_into_file "app/assets/stylesheets/application.css", " *= require foundation\n", :after => "require_self\n"
      when 'bootstrap'
        say_wizard "installing Twitter Bootstrap HTML5 design framework"
        insert_into_file "app/assets/javascripts/application.js", "//= require twitter/bootstrap\n", :after => "jquery_ujs\n"
        insert_into_file "app/assets/stylesheets/application.css", " *= require twitter/bootstrap\n", :after => "require_self\n"
      when 'skeleton'
        say_wizard "installing Skeleton HTML5 design framework"
        get "https://raw.github.com/necolas/normalize.css/master/normalize.css", "app/assets/stylesheets/normalize.css.scss"
        get "https://raw.github.com/dhgamache/Skeleton/master/stylesheets/base.css", "app/assets/stylesheets/base.css.scss"
        get "https://raw.github.com/dhgamache/Skeleton/master/stylesheets/layout.css", "app/assets/stylesheets/layout.css.scss"
        get "https://raw.github.com/dhgamache/Skeleton/master/stylesheets/skeleton.css", "app/assets/stylesheets/skeleton.css.scss"
        get "https://raw.github.com/dhgamache/Skeleton/master/javascripts/tabs.js", "app/assets/javascripts/tabs.js"
      when 'normalize'
        say_wizard "Normalizing CSS for consistent styling"
        get "https://raw.github.com/necolas/normalize.css/master/normalize.css", "app/assets/stylesheets/normalize.css.scss"
      when 'reset'
        say_wizard "Resetting all CSS to eliminate styling"
        get "https://raw.github.com/paulirish/html5-boilerplate/master/css/style.css", "app/assets/stylesheets/reset.css.scss"
    end
    # Download HTML5 Boilerplate JavaScripts
    get "https://raw.github.com/paulirish/html5-boilerplate/master/js/libs/modernizr-2.0.6.min.js", "app/assets/javascripts/modernizr.js"
    # Download HTML5 Boilerplate Site Root Assets
    get "https://raw.github.com/paulirish/html5-boilerplate/master/apple-touch-icon-114x114-precomposed.png", "public/apple-touch-icon-114x114-precomposed.png"
    get "https://raw.github.com/paulirish/html5-boilerplate/master/apple-touch-icon-57x57-precomposed.png", "public/apple-touch-icon-57x57-precomposed.png"
    get "https://raw.github.com/paulirish/html5-boilerplate/master/apple-touch-icon-72x72-precomposed.png", "public/apple-touch-icon-72x72-precomposed.png"
    get "https://raw.github.com/paulirish/html5-boilerplate/master/apple-touch-icon-precomposed.png", "public/apple-touch-icon-precomposed.png"
    get "https://raw.github.com/paulirish/html5-boilerplate/master/apple-touch-icon.png", "public/apple-touch-icon.png"
    get "https://raw.github.com/paulirish/html5-boilerplate/master/crossdomain.xml", "public/crossdomain.xml"
    get "https://raw.github.com/paulirish/html5-boilerplate/master/humans.txt", "public/humans.txt"
    # Set up the default application layout
    if recipes.include? 'haml'
      # create some Haml helpers
      # We have to use single-quote-style-heredoc to avoid interpolation.
      inject_into_file 'app/controllers/application_controller.rb', :after => "protect_from_forgery\n" do <<-'RUBY'
  include FrontendHelpers::Html5Helper
RUBY
      end
      # Haml version of default application layout
      remove_file 'app/views/layouts/application.html.erb'
      remove_file 'app/views/layouts/application.html.haml'
      # There is Haml code in this script. Changing the indentation is perilous between HAMLs.
      create_file 'app/views/layouts/application.html.haml' do <<-HAML
- html_tag class: 'no-js' do
  %head
    %title #{app_name}
    %meta{:charset => "utf-8"}
    %meta{"http-equiv" => "X-UA-Compatible", :content => "IE=edge,chrome=1"}
    %meta{:name => "viewport", :content => "width=device-width, initial-scale=1, maximum-scale=1"}
    = stylesheet_link_tag :application
    = javascript_include_tag :application
    = csrf_meta_tags
  %body{:class => params[:controller]}
    #container.container
      %header
        - flash.each do |name, msg|
          = content_tag :div, msg, :id => "flash_\#{name}" if msg.is_a?(String)
      #main{:role => "main"}
        = yield
      %footer
HAML
      end
    else
      # ERB version of default application layout
      remove_file 'app/views/layouts/application.html.erb'
      remove_file 'app/views/layouts/application.html.haml'
      create_file 'app/views/layouts/application.html.erb' do <<-ERB
<!doctype html>
<!--[if lt IE 7]> <html class="no-js ie6 oldie" lang="en"> <![endif]-->
<!--[if IE 7]>    <html class="no-js ie7 oldie" lang="en"> <![endif]-->
<!--[if IE 8]>    <html class="no-js ie8 oldie" lang="en"> <![endif]-->
<!--[if gt IE 8]><!--> <html class="no-js" lang="en"> <!--<![endif]-->
<head>
  <meta charset="utf-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>#{app_name}</title>
  <meta name="description" content="">
  <meta name="author" content="">
  <%= stylesheet_link_tag    "application" %>
  <%= javascript_include_tag "application" %>
  <%= csrf_meta_tags %>
</head>
<body class="<%= params[:controller] %>">
  <div id="container" class="container">
    <header>
    </header>
    <div id="main" role="main">
      <%= yield %>
    </div>
    <footer>
    </footer>
  </div> <!--! end of #container -->
</body>
</html>
ERB
      end
      inject_into_file 'app/views/layouts/application.html.erb', :after => "<header>\n" do
  <<-ERB
      <%- flash.each do |name, msg| -%>
        <%= content_tag :div, msg, :id => "flash_\#{name}" if msg.is_a?(String) %>
      <%- end -%>
ERB
      end
    end
  end
elsif recipes.include? 'rails 3.0'
  say_wizard "Not supported for Rails version #{Rails::VERSION::STRING}. HTML5 recipe skipped."
else
  say_wizard "Don't know what to do for Rails version #{Rails::VERSION::STRING}. HTML5 recipe skipped."
end


__END__

name: html5
description: "Install HTML5 Boilerplate."
author: RailsApps

category: other
tags: [utilities, configuration]

config:
  - css_option:
      type: multiple_choice
      prompt: "Which design framework would you like for HTML5?"
      choices: [["None", nothing], ["Zurb Foundation", foundation], ["Twitter Bootstrap", bootstrap], ["Skeleton", skeleton], ["Normalize CSS for consistent styling", normalize], ["Reset all CSS to eliminate styling", reset]]

