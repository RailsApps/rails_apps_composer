if config['backbone']
  gem 'rails-backbone', :version => '>= 0.7.2'
  after_bundler do
    generate 'backbone:install'
  end
else
  recipes.delete('backbone')
end

__END__

name: Backbone.js
description: "Use the Backbone.js MVC framework"
author: ashley_woodard

exclusive: javascript_framework
category: assets
tags: [javascript, framework]

config:
  - haml:
      type: boolean
      prompt: Would you like to use the Backbone.js MVC framework?
