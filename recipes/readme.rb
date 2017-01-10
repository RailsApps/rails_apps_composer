# Application template recipe for the rails_apps_composer. Change the recipe here:
# https://github.com/RailsApps/rails_apps_composer/blob/master/recipes/readme.rb

stage_three do
  say_wizard "recipe stage three"

  # remove default READMEs
  %w{
    README
    README.rdoc
    doc/README_FOR_APP
  }.each { |file| remove_file file }

  remove_file 'README.md'
  create_file 'README.md', "#{app_name.humanize.titleize}\n================\n\n"

  if prefer :deployment, 'heroku'
    append_to_file 'README.md' do <<-TEXT
[![Deploy to Heroku](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy)

TEXT
    end
  end

  append_to_file 'README.md' do <<-TEXT
Ruby on Rails
-------------

This application requires:

- Ruby #{RUBY_VERSION}
- Rails #{Rails::VERSION::STRING}

Getting Started
---------------

Documentation and Support
-------------------------

Issues
-------------

Similar Projects
----------------

Contributing
------------

Credits
-------

License
-------
TEXT
  end

  git :add => '-A' if prefer :git, true
  git :commit => '-qm "rails_apps_composer: add README files"' if prefer :git, true

end

__END__

name: readme
description: "Build a README file for your application."
author: RailsApps

requires: [setup]
run_after: [setup]
category: configuration
