# Application template recipe for the rails3_devise_wizard. Check for a newer version here:
# https://github.com/fortuity/rails3_devise_wizard/blob/master/recipes/ban_spiders.rb

after_bundler do

  # ban spiders from your site by changing robots.txt
  gsub_file 'public/robots.txt', /# User-Agent/, 'User-Agent'
  gsub_file 'public/robots.txt', /# Disallow/, 'Disallow'

end

__END__

name: BanSpiders
description: "Ban spiders from the site by changing robots.txt."
author: fortuity

run_after: [cleanup]
category: other
tags: [utilities, configuration]
