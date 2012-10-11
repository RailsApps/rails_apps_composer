# Application template recipe for the rails_apps_composer. Change the recipe here:
# https://github.com/RailsApps/rails_apps_composer/blob/master/recipes/init.rb

after_everything do
  say_wizard "recipe running after everything"
  ### PREPARE SEED ###
  if prefer :authentication, 'devise'
    if (prefer :authorization, 'cancan') && !(prefer :railsapps, 'rails-prelaunch-signup')
      append_file 'db/seeds.rb' do <<-FILE
puts 'CREATING ROLES'
Role.create([
  { :name => 'admin' }, 
  { :name => 'user' }, 
  { :name => 'VIP' }
], :without_protection => true)
FILE
      end
    end    
    if (prefer :devise_modules, 'confirmable') || (prefer :devise_modules, 'invitable')
      ## DEVISE-CONFIRMABLE
      append_file 'db/seeds.rb' do <<-FILE
puts 'SETTING UP DEFAULT USER LOGIN'
user = User.create! :name => 'First User', :email => 'user@example.com', :password => 'please', :password_confirmation => 'please'
user.confirm!
puts 'New user created: ' << user.name
user2 = User.create! :name => 'Second User', :email => 'user2@example.com', :password => 'please', :password_confirmation => 'please'
user2.confirm!
puts 'New user created: ' << user2.name
FILE
      end
    else
      ## DEVISE-DEFAULT
      append_file 'db/seeds.rb' do <<-FILE
puts 'SETTING UP DEFAULT USER LOGIN'
user = User.create! :name => 'First User', :email => 'user@example.com', :password => 'please', :password_confirmation => 'please'
puts 'New user created: ' << user.name
user2 = User.create! :name => 'Second User', :email => 'user2@example.com', :password => 'please', :password_confirmation => 'please'
puts 'New user created: ' << user2.name
FILE
      end
    end
    if prefer :starter_app, 'subdomains_app'
      gsub_file 'db/seeds.rb', /First User/, 'user1'
      gsub_file 'db/seeds.rb', /Second User/, 'user2'
    end
    if prefer :authorization, 'cancan'
      append_file 'db/seeds.rb' do <<-FILE
user.add_role :admin
user2.add_role :VIP
FILE
      end
    end
    if prefer :railsapps, 'rails-prelaunch-signup'
      gsub_file 'db/seeds.rb', /user2.add_role :VIP/, ''
    end
    ## DEVISE-INVITABLE
    if prefer :devise_modules, 'invitable'
      run 'bundle exec rake db:migrate'
      generate 'devise_invitable user'
    end    
  end
  ### APPLY SEED ###
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
  run 'bundle exec rake db:seed'
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
