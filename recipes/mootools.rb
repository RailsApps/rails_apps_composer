inside "public/javascripts" do
  get "https://github.com/kevinvaldek/mootools-ujs/raw/master/Source/rails.js", "rails.js"
  get "http://ajax.googleapis.com/ajax/libs/mootools/1.3.1/mootools-yui-compressed.js", "mootools.min.js"
end

gsub_file "config/application.rb", /# JavaScript.*\n/, ""
gsub_file "config/application.rb", /# config\.action_view\.javascript.*\n/, ""

application do
  "\n    config.action_view.javascript_expansions[:defaults] = %w(mootools.min rails)\n"
end

__END__

name: MooTools
description: "Adds MooTools and MooTools-compatible UJS helpers."
author: mbleigh

exclusive: javascript_framework
category: assets 
tags: [javascript, framework]

args: ["-J"]
