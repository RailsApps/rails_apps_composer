# Application template recipe for the rails3_devise_wizard. Check for a newer version here:
# https://github.com/fortuity/rails3_devise_wizard/blob/master/recipes/devise.rb

gem "devise", ">= 1.2.1"

after_bundler do
  
  # Run the Devise generator
  generate 'devise:install'

  if recipes.include? 'mongo_mapper'
    gem 'mm-devise'
    gsub_file 'config/initializers/devise.rb', 'devise/orm/', 'devise/orm/mongo_mapper_active_model'
    generate 'mongo_mapper:devise User'
  elsif recipes.include? 'mongoid'
    # Nothing to do (Devise changes its initializer automatically when Mongoid is detected)
    # gsub_file 'config/initializers/devise.rb', 'devise/orm/active_record', 'devise/orm/mongoid'
  end
  
  # Prevent logging of password_confirmation
  gsub_file 'config/application.rb', /:password/, ':password, :password_confirmation'

  # Generate models and routes for a User
  generate 'devise user'

end

__END__

name: Devise
description: Utilize Devise for authentication, automatically configured for your selected ORM.
author: fortuity

run_before: [add_user_name, devise_navigation, home_page_users, seed_database, users_page]
category: authentication
exclusive: authentication
