# Application template recipe for the rails_apps_composer. Change the recipe here:
# https://github.com/RailsApps/rails_apps_composer/blob/master/recipes/init.rb

after_everything do
  say_wizard "recipe running after everything"
  ### CONFIGURATION FILE ###
  ## EMAIL
  case prefs[:email]
    when 'none'
      credentials = ''
    when 'smtp'
      credentials = ''
    when 'gmail'
      credentials = "GMAIL_USERNAME: Your_Username\nGMAIL_PASSWORD: Your_Password\n"
    when 'sendgrid'
      credentials = "SENDGRID_USERNAME: Your_Username\nSENDGRID_PASSWORD: Your_Password\n"
    when 'mandrill'
      credentials = "MANDRILL_USERNAME: Your_Username\nMANDRILL_API_KEY: Your_API_Key\n"
  end
  append_file 'config/application.yml', credentials
  ## DEFAULT USER
  append_file 'config/application.yml' do <<-FILE
ADMIN_NAME: First User
ADMIN_EMAIL: user@example.com
ADMIN_PASSWORD: changeme
FILE
  end
  ## AUTHENTICATION
  if prefer :authentication, 'omniauth'
    append_file 'config/application.yml' do <<-FILE
OMNIAUTH_PROVIDER_KEY: Your_OmniAuth_Provider_Key
OMNIAUTH_PROVIDER_SECRET: Your_OmniAuth_Provider_Secret
FILE
    end
  end
  ## AUTHORIZATION
  if (prefer :authorization, 'cancan')
    append_file 'config/application.yml', "ROLES: [admin, user, VIP]\n"
  end
  ### SUBDOMAINS ###
  copy_from_repo 'config/application.yml', :repo => 'https://raw.github.com/RailsApps/rails3-subdomains/master/' if prefer :starter_app, 'subdomains_app'
  ### APPLICATION.EXAMPLE.YML ###
  copy_file destination_root + '/config/application.yml', destination_root + '/config/application.example.yml'
  ### DATABASE SEED ###
  append_file 'db/seeds.rb' do <<-FILE
# Environment variables (ENV['...']) are set in the file config/application.yml.
# See http://railsapps.github.com/rails-environment-variables.html
FILE
  end
  if (prefer :authorization, 'cancan')
    unless prefer :orm, 'mongoid'
      append_file 'db/seeds.rb' do <<-FILE
puts 'ROLES'
YAML.load(ENV['ROLES']).each do |role|
  Role.find_or_create_by_name({ :name => role }, :without_protection => true)
  puts 'role: ' << role
end
FILE
      end
    else
      append_file 'db/seeds.rb' do <<-FILE
puts 'ROLES'
YAML.load(ENV['ROLES']).each do |role|
  Role.mongo_session['roles'].insert({ :name => role })
  puts 'role: ' << role
end
FILE
      end
    end
  end
  ## DEVISE-DEFAULT
  unless prefer :authentication, 'omniauth'
    append_file 'db/seeds.rb' do <<-FILE
puts 'DEFAULT USERS'
user = User.find_or_create_by_email :name => ENV['ADMIN_NAME'].dup, :email => ENV['ADMIN_EMAIL'].dup, :password => ENV['ADMIN_PASSWORD'].dup, :password_confirmation => ENV['ADMIN_PASSWORD'].dup
puts 'user: ' << user.name
FILE
    end
    # Mongoid doesn't have a 'find_or_create_by' method
    gsub_file 'db/seeds.rb', /find_or_create_by_email/, 'create!' if prefer :orm, 'mongoid'
  end
  ## DEVISE-CONFIRMABLE
  if (prefer :devise_modules, 'confirmable') || (prefer :devise_modules, 'invitable')
    append_file 'db/seeds.rb', "user.confirm!\n"
  end
  if (prefer :authorization, 'cancan') && !(prefer :authentication, 'omniauth')
    append_file 'db/seeds.rb', 'user.add_role :admin'
  end
  ## DEVISE-INVITABLE
  if prefer :devise_modules, 'invitable'
    run 'bundle exec rake db:migrate'
    generate 'devise_invitable user'
  end
  ### APPLY DATABASE SEED ###
  unless prefer :orm, 'mongoid'
    ## ACTIVE_RECORD
    say_wizard "applying migrations and seeding the database"
    run 'bundle exec rake db:migrate'
    run 'bundle exec rake db:test:prepare'
  else
    ## MONGOID
    say_wizard "dropping database, creating indexes and seeding the database"
    run 'bundle exec rake db:drop'
    run 'bundle exec rake db:mongoid:create_indexes'
  end
  unless prefer :railsapps, 'rails-recurly-subscription-saas'
    run 'bundle exec rake db:seed'
  end
  ### GIT ###
  git :add => '-A' if prefer :git, true
  git :commit => '-qm "rails_apps_composer: set up database"' if prefer :git, true
end # after_everything

__END__

name: init
description: "Set up and initialize database."
author: RailsApps

requires: [setup, gems, models]
run_after: [setup, gems, models]
category: initialize
