# Application template recipe for the rails_apps_composer. Check for a newer version here:
# https://github.com/RailsApps/rails_apps_composer/blob/master/recipes/extras.rb

if config['footnotes']
  say_wizard "Adding 'rails-footnotes'"
  gem 'rails-footnotes', '>= 3.7', :group => :development
  after_bundler do
    generate 'rails_footnotes:install'
  end
end

if config['ban_spiders']
  say_wizard "Banning spiders by modifying 'public/robots.txt'"
  after_bundler do
    # ban spiders from your site by changing robots.txt
    gsub_file 'public/robots.txt', /# User-Agent/, 'User-Agent'
    gsub_file 'public/robots.txt', /# Disallow/, 'Disallow'
  end
end

if config['paginate']
  say_wizard "Adding 'will_paginate'"
  if recipes.include? 'mongoid'
    gem 'will_paginate_mongoid'
  else
    gem 'will_paginate', '>= 3.0.3'
  end
  recipes << 'paginate'
end

if config['jsruntime']
  say_wizard "Adding 'therubyracer' JavaScript runtime gem"
  # maybe it was already added by the html5 recipe for bootstrap_less?
  unless recipes.include? 'jsruntime'
    gem 'therubyracer', :group => :assets, :platform => :ruby
  end
end

__END__

name: Extras
description: "Various extras including 'ban_spiders' and 'rails-footnotes'."
author: RailsApps

category: other
tags: [utilities, configuration]

config:
  - footnotes:
      type: boolean
      prompt: Would you like to use 'rails-footnotes' (it's SLOW!)?
  - ban_spiders:
      type: boolean
      prompt: Would you like to set a robots.txt file to ban spiders?
  - paginate:
      type: boolean
      prompt: Would you like to add 'will_paginate' for pagination?
  - jsruntime:
      type: boolean
      prompt: Add 'therubyracer' JavaScript runtime (for Linux users without node.js)?
