inside "public/javascripts" do
  get "https://github.com/rails/jquery-ujs/raw/master/src/rails.js", "rails.js"
  get "http://code.jquery.com/jquery-1.5.min.js", "jquery.js"
end

application do
  "\nconfig.action_view.javascript_expansions[:defaults] = %w(jquery rails)\n"
end

gsub_file "config/application.rb", /# JavaScript.*\n/, ""
gsub_file "config/application.rb", /# config\.action_view\.javascript.*\n/, ""

__END__

category: javascript
name: jQuery
description: "Adds the latest jQuery and Rails UJS helpers for jQuery."
