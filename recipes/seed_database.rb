# Application template recipe for the rails3_devise_wizard. Check for a newer version here:
# https://github.com/fortuity/rails3_devise_wizard/blob/master/recipes/seed_database.rb


after_bundler do

  if recipes.include? 'devise'

    if recipes.include? 'mongoid'
      # create a default user
      append_file 'db/seeds.rb' do <<-FILE
puts 'EMPTY THE MONGODB DATABASE'
Mongoid.master.collections.reject { |c| c.name =~ /^system/}.each(&:drop)
puts 'SETTING UP DEFAULT USER LOGIN'
user = User.create! :name => 'First User', :email => 'user@test.com', :password => 'please', :password_confirmation => 'please'
puts 'New user created: ' << user.name
FILE
      end
    end

    run 'rake db:seed'

  end

end

__END__

name: SeedDatabase
description: "Create a database seed file with a default user."
author: fortuity

requires: [devise]
run_after: [home_page_users]
category: other
tags: [utilities, configuration]
