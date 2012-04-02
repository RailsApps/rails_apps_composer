if config['compass']
  gem 'compass', :version => '~> 0.12.1', :group => [:assets]
  gem 'compass-rails', :version => '~> 1.0.0', :group => [:assets]
  after_bundler do
    remove_file 'app/assets/stylesheets/application.css'

    if File.exist?("config/initializers/sass.rb")
      create_file "app/assets/stylesheets/application.css.sass" do <<-SASS
//= require_self
//= require_tree .

@import compass
@import _blueprint
      SASS
      end
    else
      create_file "app/assets/stylesheets/application.css.scss" do <<-SCSS
//= require_self
//= require_tree .

@import "compass";
@import "_blueprint";
      SCSS
      end
    end
  end
else
  recipes.delete('compass')
end

__END__

name: Compass
description: "Utilize Compass framework for SASS."
author: ashley_woodard

requires: [sass]
run_after: [sass]
exclusive: css_framework
category: assets
tags: [css]

config:
  - compass:
      type: boolean
      prompt: Would you like to use Compass for stylesheets?