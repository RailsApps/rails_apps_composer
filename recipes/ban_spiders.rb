# Application template recipe for the rails3_devise_wizard. Check for a newer version here:
# https://github.com/fortuity/rails3_devise_wizard/blob/master/recipes/ban_spiders.rb

if config['ban_spiders']
  after_bundler do
    # ban spiders from your site by changing robots.txt
    gsub_file 'public/robots.txt', /# User-Agent/, 'User-Agent'
    gsub_file 'public/robots.txt', /# Disallow/, 'Disallow'
  end
else
  recipes.delete('ban_spiders')
end

__END__

name: BanSpiders
description: "Ban spiders from the site by changing robots.txt."
author: fortuity

category: other
tags: [utilities, configuration]

config:
  - ban_spiders:
      type: boolean
      prompt: Would you like to set a robots.txt file to ban spiders?