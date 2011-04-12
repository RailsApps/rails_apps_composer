# Application template recipe for the rails3_devise_wizard. Check for a newer version here:
# https://github.com/fortuity/rails3_devise_wizard/blob/master/recipes/css_setup.rb

after_bundler do

  # Add a stylesheet with styles for a horizontal menu and flash messages
  create_file 'public/stylesheets/application.css' do <<-CSS
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
  end

end

__END__

name: CssSetup
description: "Add a stylesheet with styles for a horizontal menu and flash messages."
author: fortuity

run_after: [users_page]
category: other
tags: [utilities, configuration]
