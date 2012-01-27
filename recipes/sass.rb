if recipes.include? 'rails 3.0'
  gem 'sass', '>= 3.1.6'
elsif recipes.include? 'rails 3.1'
  gem 'sass', '>= 3.1.6'
elsif recipes.include? 'rails 3.2'
  gem 'sass', '>= 3.1.12'
  gem 'sass-rails', '>= 3.2.4'
end

if config['sass']
  after_bundler do
    create_file 'config/initializers/sass.rb' do <<-RUBY
Rails.application.config.generators.stylesheet_engine = :sass
RUBY
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
