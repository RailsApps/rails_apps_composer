
if config['sass']
  gem 'sass', '>= 3.1.12'
  after_bundler do
    create_file 'config/initializers/sass.rb' do <<-RUBY
Rails.application.config.generators.stylesheet_engine = :sass
RUBY
    end
    remove_file 'app/assets/stylesheets/application.css'
    if recipes.include? 'bourbon'
      create_file 'app/assets/stylesheets/application.css.sass' do <<-SASS
//= require_self
//= require_tree .

@import 'bourbon'
      SASS
      end
    else
      create_file 'app/assets/stylesheets/application.css.sass' do <<-SASS
//= require_self
//= require_tree .
      SASS
      end
    end
  end
end

__END__

name: SASS
description: "Utilize SASS for really awesome stylesheets!"
author: mbleigh, mrc2407, & ashley_woodard

exclusive: css_replacement
category: assets
tags: [css]

config:
  - sass:
      type: boolean
      prompt: Would you like to use SASS syntax instead of SCSS?
