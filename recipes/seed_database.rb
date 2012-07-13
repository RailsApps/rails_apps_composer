# Application template recipe for the rails_apps_composer. Check for a newer version here:
# https://github.com/RailsApps/rails_apps_composer/blob/master/recipes/seed_database.rb

after_bundler do
  say_wizard "SeedDatabase recipe running 'after bundler'"
  if recipes.include? 'devise'
    if recipes.include? 'devise-confirmable'
      append_file 'db/seeds.rb' do <<-FILE
puts 'SETTING UP DEFAULT USER LOGIN'
user = User.create! :name => 'First User', :email => 'user@example.com', :password => 'please', :password_confirmation => 'please', :confirmed_at => Time.now.utc
puts 'New user created: ' << user.name
user2 = User.create! :name => 'Second User', :email => 'user2@example.com', :password => 'please', :password_confirmation => 'please', :confirmed_at => Time.now.utc
puts 'New user created: ' << user2.name
FILE
      end
    else
      append_file 'db/seeds.rb' do <<-FILE
puts 'SETTING UP DEFAULT USER LOGIN'
user = User.create! :name => 'First User', :email => 'user@example.com', :password => 'please', :password_confirmation => 'please'
puts 'New user created: ' << user.name
user2 = User.create! :name => 'Second User', :email => 'user2@example.com', :password => 'please', :password_confirmation => 'please'
puts 'New user created: ' << user2.name
FILE
      end
    end
    if recipes.include? 'authorization'
      append_file 'db/seeds.rb' do <<-FILE
user.add_role :admin
FILE
      end
    end
  end
end

after_everything do
  if recipes.include? 'devise-invitable'
    run 'bundle exec rake db:migrate'
    generate 'devise_invitable user'
  end
  unless recipes.include? 'mongoid'
    say_wizard "applying migrations and seeding the database"
    run 'bundle exec rake db:migrate'
    run 'bundle exec rake db:test:prepare'
  else
    say_wizard "dropping database, creating indexes and seeding the database"
    run 'rake db:drop'
    run 'rake db:mongoid:create_indexes'
  end
  run 'bundle exec rake db:seed'
end

__END__

name: SeedDatabase
description: "Create a database seed file with a default user."
author: RailsApps

category: other
tags: [utilities, configuration]
