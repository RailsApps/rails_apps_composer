gem 'rails-backbone', :version => '~> 0.6.1'

after_bundler do
  generate 'backbone:install'
end

__END__

name: Backbone.js
description: "Use the Backbone.js MVC framework"
author: ashley_woodard

exclusive: javascript_framework
category: assets
tags: [javascript, framework]
