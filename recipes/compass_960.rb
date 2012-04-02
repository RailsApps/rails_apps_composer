if config['compass_960']
  gem 'compass-960-plugin', :version => '~> 0.10.4', :group => [:assets]
  after_bundler do

    #create compass.rb initializer
    create_file 'config/initializers/compass.rb' do <<-RUBY
require 'ninesixty'
    RUBY
    end

    if File.exist?('config/initializers/sass.rb')
      inject_into_file 'app/assets/stylesheets/application.css.sass', :after => "@import compass\n" do <<-SASS
@import 960/grid
      SASS
      end
    else
      inject_into_file 'app/assets/stylesheets/application.css.scss', :after => "@import \"compass\";\n" do <<-SCSS
@import "960/grid";
      SCSS
      end
    end

    inject_into_file 'config/application.rb', :after => "Rails::Application\n" do <<-RUBY
      config.sass.load_paths << "#{Gem.loaded_specs['compass'].full_gem_path}/frameworks/compass/stylesheets"
      config.sass.load_paths << "#{Gem.loaded_specs['compass-960-plugin'].full_gem_path}/stylesheets"
    RUBY
    end

  end
else
  recipes.delete('compass_960')
end
__END__

name: Compass 960
description: "Add compass-960-plugin for Compass"
author: porta

requires: [compass]
run_after: [compass]
exclusive: css_framework
category: assets
tags: [css]

config:
  - compass_960:
      type: boolean
      prompt: Would you like to add Compass 960 plugin for Compass?