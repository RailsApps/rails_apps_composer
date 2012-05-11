# Application template recipe for the rails_apps_composer. Check for a newer version here:
# https://github.com/RailsApps/rails_apps_composer/blob/master/recipes/seed_database.rb


after_bundler do

  say_wizard "SeedDatabase recipe running 'after bundler'"

  run 'bundle exec rake db:migrate' unless recipes.include? 'mongoid'

  if recipes.include? 'devise-invitable'
    generate 'devise_invitable user'
    unless recipes.include? 'mongoid'
      run 'bundle exec rake db:migrate'
    end
  end
  
  # clone the schema changes to the test database
  run 'bundle exec rake db:test:prepare' unless recipes.include? 'mongoid'
  
  if recipes.include? 'mongoid'
    append_file 'db/seeds.rb' do <<-FILE
puts 'EMPTY THE MONGODB DATABASE'
Mongoid.master.collections.reject { |c| c.name =~ /^system/}.each(&:drop)
FILE
    end
  end

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
  
  say_wizard "seeding the database"
  run 'bundle exec rake db:seed'
  run 'rake db:mongoid:create_indexes' if recipes.include? 'mongoid'
  
end

__END__

name: SeedDatabase
description: "Create a database seed file with a default user."
author: RailsApps

category: other
tags: [utilities, configuration]
