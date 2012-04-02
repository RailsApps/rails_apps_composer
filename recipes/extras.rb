# Application template recipe for the rails_apps_composer. Check for a newer version here:
# https://github.com/RailsApps/rails_apps_composer/blob/master/recipes/extras.rb

if config['footnotes']
  say_wizard "Extras recipe running 'after bundler'"
  gem 'rails-footnotes', '>= 3.7', :group => :development
  after_bundler do
    generate 'rails_footnotes:install'
  end
else
  recipes.delete('footnotes')
end

if config['ban_spiders']
  say_wizard "BanSpiders recipe running 'after bundler'"
  after_bundler do
    # ban spiders from your site by changing robots.txt
    gsub_file 'public/robots.txt', /# User-Agent/, 'User-Agent'
    gsub_file 'public/robots.txt', /# Disallow/, 'Disallow'
  end
else
  recipes.delete('ban_spiders')
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
