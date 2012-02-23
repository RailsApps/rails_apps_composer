# Application template recipe for the rails_apps_composer. Check for a newer version here:
# https://github.com/RailsApps/rails_apps_composer/blob/master/recipes/seed_database.rb


after_bundler do

  say_wizard "SeedDatabase recipe running 'after bundler'"

  unless recipes.include? 'mongoid'
    run 'bundle exec rake db:migrate'
  end

  if recipes.include? 'devise-invitable'
    generate 'devise_invitable user'
    unless recipes.include? 'mongoid'
      run 'bundle exec rake db:migrate'
    end
  end
  
  # clone the schema changes to the test database
  unless recipes.include? 'mongoid'
    run 'bundle exec rake db:test:prepare'
  end
  
  if recipes.include? 'mongoid'
    append_file 'db/seeds.rb' do <<-FILE
puts 'EMPTY THE MONGODB DATABASE'
Mongoid.master.collections.reject { |c| c.name =~ /^system/}.each(&:drop)
FILE
    end
  end

  if recipes.include? 'devise'
    # create a default user
    append_file 'db/seeds.rb' do <<-FILE
puts 'SETTING UP DEFAULT USER LOGIN'
user = User.create! :name => 'First User', :email => 'user@example.com', :password => 'please', :password_confirmation => 'please'
puts 'New user created: ' << user.name
FILE
    end
    if recipes.include? 'devise-confirmable'
      gsub_file 'db/seeds.rb', /:password_confirmation => 'please'/, ":password_confirmation => 'please', :confirmed_at => DateTime.now"
    end
  end

  run 'bundle exec rake db:seed'

end

__END__

name: SeedDatabase
description: "Create a database seed file with a default user."
author: RailsApps

category: other
tags: [utilities, configuration]
