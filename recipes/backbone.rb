if config['backbone']
  if recipes.include? 'rails 3.0' 
    gem 'backbone-rails', :version => '~> 0.5.2'
  elsif recipes.include? 'rails 3.1'
    # rails-backbone is preferred, but only support rails 3.1+
    gem 'rails-backbone', :version => '~> 0.5.3'
  elsif recipes.include? 'rails 3.2'
    gem 'rails-backbone', :version => '~> 0.6.1'
  end 
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
