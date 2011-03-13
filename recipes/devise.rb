gem 'devise'

after_bundler do
  generate 'devise:install'

  if recipes.include? 'mongo_mapper'
    gem 'mm-devise'
    gsub_file 'config/intializers/devise.rb', 'devise/orm/active_record', 'devise/orm/mongo_mapper_active_model'
  elsif recipes.include? 'mongoid'
    gsub_file 'config/intializers/devise.rb', 'devise/orm/active_record', 'devise/orm/mongoid'
  end      

  generate 'devise user'
end

__END__

name: Devise
description: Utilize Devise for authentication, automatically configured for your selected ORM.
author: mbleigh

category: authentication
exclusive: authentication
