# Application template recipe for the rails_apps_composer. Check for a newer version here:
# https://github.com/RailsApps/rails_apps_composer/blob/master/recipes/html5.rb

if config['html5']
  if recipes.include? 'rails 3.1'
    after_bundler do
      say_wizard "HTML5 Boilerplate recipe running 'after bundler'"
      # Download HTML5 Boilerplate JavaScripts
      get "https://raw.github.com/paulirish/html5-boilerplate/master/js/libs/modernizr-2.0.min.js", "app/assets/javascripts/modernizr.js"
      get "https://raw.github.com/paulirish/html5-boilerplate/master/js/libs/respond.min.js", "app/assets/javascripts/respond.js"
      # Download stylesheet to normalize or reset CSS
      case config['css_option']
        when 'skeleton'
          get "https://raw.github.com/necolas/normalize.css/master/normalize.css", "app/assets/stylesheets/normalize.css.scss"
          get "https://raw.github.com/dhgamache/Skeleton/master/stylesheets/base.css", "app/assets/stylesheets/base.css.scss"
          get "https://raw.github.com/dhgamache/Skeleton/master/stylesheets/layout.css", "app/assets/stylesheets/layout.css.scss"
          get "https://raw.github.com/dhgamache/Skeleton/master/stylesheets/skeleton.css", "app/assets/stylesheets/skeleton.css.scss"
          get "https://raw.github.com/dhgamache/Skeleton/master/javascripts/app.js", "app/assets/javascripts/tabs.js"
        when 'normalize'
          get "https://raw.github.com/necolas/normalize.css/master/normalize.css", "app/assets/stylesheets/normalize.css.scss"
        when 'reset'
          get "https://raw.github.com/paulirish/html5-boilerplate/master/css/style.css", "app/assets/stylesheets/reset.css.scss"
      end
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
        inject_into_file 'app/helpers/application_helper.rb', :after => "ApplicationHelper\n" do <<-'RUBY'
  # Create a named haml tag to wrap IE conditional around a block
  # http://paulirish.com/2008/conditional-stylesheets-vs-css-hacks-answer-neither
  def ie_tag(name=:body, attrs={}, &block)
    attrs.symbolize_keys!
    haml_concat("<!--[if lt IE 7]> #{ tag(name, add_class('ie6', attrs), true) } <![endif]-->".html_safe)
    haml_concat("<!--[if IE 7]>    #{ tag(name, add_class('ie7', attrs), true) } <![endif]-->".html_safe)
    haml_concat("<!--[if IE 8]>    #{ tag(name, add_class('ie8', attrs), true) } <![endif]-->".html_safe)
    haml_concat("<!--[if gt IE 8]><!-->".html_safe)
    haml_tag name, attrs do
      haml_concat("<!--<![endif]-->".html_safe)
      block.call
    end
  end

  def ie_html(attrs={}, &block)
    ie_tag(:html, attrs, &block)
  end

  def ie_body(attrs={}, &block)
    ie_tag(:body, attrs, &block)
  end

private

  def add_class(name, attrs)
    classes = attrs[:class] || ''
    classes.strip!
    classes = ' ' + classes if !classes.blank?
    classes = name + classes
    attrs.merge(:class => classes)
  end
RUBY
        end
        # Haml version of default application layout
        remove_file 'app/views/layouts/application.html.erb'
        remove_file 'app/views/layouts/application.html.haml'
        # There is Haml code in this script. Changing the indentation is perilous between HAMLs.
        create_file 'app/views/layouts/application.html.haml' do <<-HAML
- ie_html :lang => 'en', :class => 'no-js' do
  %head
    %title #{app_name}
    %meta{:charset => "utf-8"}
    %meta{"http-equiv" => "X-UA-Compatible", :content => "IE=edge,chrome=1"}
    %meta{:name => "viewport", :content => "width=device-width, initial-scale=1, maximum-scale=1"}
    = stylesheet_link_tag :application
    = javascript_include_tag :application
    = csrf_meta_tags
    %body
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
<body>
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
    say_wizard "Not supported for Rails version #{Rails::VERSION::STRING}. HTML5 Boilerplate recipe skipped."
  else
    say_wizard "Don't know what to do for Rails version #{Rails::VERSION::STRING}. HTML5 Boilerplate recipe skipped."
  end
else
  say_wizard "HTML5 Boilerplate recipe skipped. No CSS styles added."
  recipes.delete('html5')
end

__END__

name: html5
description: "Install HTML5 Boilerplate."
author: RailsApps

category: other
tags: [utilities, configuration]

config:
  - html5:
      type: boolean
      prompt: Would you like to install HTML5 Boilerplate?
  - css_option:
      type: multiple_choice
      prompt: "If you've chosen HTML5 Boilerplate, how do you like your CSS?"
      choices: [["Do nothing", nothing], ["Normalize CSS and add Skeleton styling", skeleton], ["Normalize CSS for consistent styling across browsers", normalize], ["Completely reset all CSS to eliminate styling", reset]]

