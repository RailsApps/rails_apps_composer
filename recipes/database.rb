# Application template recipe for the rails_apps_composer. Change the recipe here:
# https://github.com/RailsApps/rails_apps_composer/blob/master/recipes/database.rb

after_everything do
  say_wizard "recipe running after everything"
  ### PREPARE SEED ###
  if recipes.include? 'devise'
    if recipes.include? 'devise-confirmable'
      ## DEVISE-CONFIRMABLE
      append_file 'db/seeds.rb' do <<-FILE
puts 'SETTING UP DEFAULT USER LOGIN'
user = User.create! :name => 'First User', :email => 'user@example.com', :password => 'please', :password_confirmation => 'please', :confirmed_at => Time.now.utc
puts 'New user created: ' << user.name
user2 = User.create! :name => 'Second User', :email => 'user2@example.com', :password => 'please', :password_confirmation => 'please', :confirmed_at => Time.now.utc
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
    if recipes.include? 'subdomains'
      gsub_file 'db/seeds.rb', /First User/, 'user1'
      gsub_file 'db/seeds.rb', /Second User/, 'user2'
    end
    if recipes.include? 'cancan'
      append_file 'db/seeds.rb' do <<-FILE
user.add_role :admin
FILE
      end
    end
    ## DEVISE-INVITABLE
    if recipes.include? 'devise-invitable'
      run 'bundle exec rake db:migrate'
      generate 'devise_invitable user'
    end    
  end
  ### APPLY SEED ###
  unless recipes.include? 'mongoid'
    ## MONGOID
    say_wizard "applying migrations and seeding the database"
    run 'bundle exec rake db:migrate'
    run 'bundle exec rake db:test:prepare'
  else
    ## ACTIVE_RECORD
    say_wizard "dropping database, creating indexes and seeding the database"
    run 'bundle exec rake db:drop'
    run 'bundle exec rake db:mongoid:create_indexes'
  end
  run 'bundle exec rake db:seed'
  ### GIT ###
  git :add => '.' if recipes.include? 'git'
  git :commit => "-aqm 'rails_apps_composer: set up database'" if recipes.include? 'git'
end # after_everything

__END__

name: database
description: "Set up and initialize database."
author: RailsApps

run_after: [models]
category: other
tags: [utilities, configuration]
