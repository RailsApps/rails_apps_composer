case config['admin']
  when 'activeadmin'
    prefs[:admin] = 'activeadmin'
  when 'rails_admin'
    prefs[:admin] = 'rails_admin'
end

if prefer :admin, 'activeadmin'
  if Rails::VERSION::MAJOR.to_s == "4"
    gem 'activeadmin', github: 'gregbell/active_admin'
  else
    gem 'activeadmin'
  end
end
gem 'rails_admin' if prefer :admin, 'rails_admin'

after_bundler do
  if prefer :admin, 'active_admin'
    say_wizard "recipe installing activeadmin"
    generate 'active_admin:install'
  end
  if prefer :admin, 'rails_admin'
    say_wizard "recipe installing rails_admin"
    generate 'rails_admin:install'
  end
end

__END__

name: admin
description: "Adding rails admin gem to your application"
author: JangoSteve

category: admin
requires: [setup]
run_after: [setup]
args: -T

config:
  - admin:
      type: multiple_choice
      prompt: Install admin gem?
      choices: [ ["None", "none"], ["ActiveAdmin", "activeadmin"], ["RailsAdmin", "rails_admin"] ]
