# Application template recipe for the rails_apps_composer. Check for a newer version here:
# https://github.com/RailsApps/rails_apps_composer/blob/master/recipes/css_setup.rb

after_bundler do

  say_wizard "CssSetup recipe running 'after bundler'"

  # Add a stylesheet with styles for a horizontal menu and flash messages
  css = <<-CSS

ul.hmenu {
  list-style: none;
  margin: 0 0 2em;
  padding: 0;
}
ul.hmenu li {
  display: inline;
}
#flash_notice, #flash_alert {
  padding: 5px 8px;
  margin: 10px 0;
}
#flash_notice {
  background-color: #CFC;
  border: solid 1px #6C6;
}
#flash_alert {
  background-color: #FCC;
  border: solid 1px #C66;
}

CSS
  if recipes.include? 'rails 3.0'
    create_file 'public/stylesheets/application.css', css
  else
    append_file 'app/assets/stylesheets/application.css', css
  end

end

__END__

name: CssSetup
description: "Add a stylesheet with styles for a horizontal menu and flash messages."
author: RailsApps

category: other
tags: [utilities, configuration]
