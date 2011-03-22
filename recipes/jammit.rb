gem 'jammit'

after_bundler do
  if config['pre_commit']
    say_wizard "Adding git pre-commit hook..."
    create_file ".git/hooks/pre-commit", <<-BASH
#!/bin/sh

echo "Packaging assets with Jammit..."
jammit
git add public/assets
BASH
    run "chmod +x .git/hooks/pre-commit"
  end

  create_file "config/assets.yml", <<-YAML
javascripts:
  app:
    - public/javascripts/*.js
stylesheets:
  app:
    - public/stylesheets/*.css
YAML

  gsub_file "app/views/layouts/application.html.erb", "<%= javascript_include_tag :defaults %>", "<%= include_javascripts :app %>"
  gsub_file "app/views/layouts/application.html.erb", "<%= stylesheet_link_tag :all %>", "<%= include_stylesheets :app %>"
end

__END__

name: Jammit
description: "Use Jammit to package your application's assets."
author: mbleigh

exclusive: asset_packaging
category: assets
tags: [packaging]

config:
  - pre_commit:
      type: boolean
      prompt: "Create a git pre-commit hook to generate assets for Heroku?"
      if_recipe: heroku
