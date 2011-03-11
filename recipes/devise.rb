gem 'devise'

after_bundler do
  generate 'devise:install'

  case template['orm']
    when 'mongo_mapper'
      gem 'mm-devise'
      gsub_file 'config/intializers/devise.rb', 'devise/orm/active_record', 'devise/orm/mongo_mapper_active_model'
    when 'mongoid'
      gsub_file 'config/intializers/devise.rb', 'devise/orm/active_record', 'devise/orm/mongoid'
    when 'active_record'
      # Nothing to do
      
    generate 'devise user'
  end
end

__END__

category: authentication
name: Devise
description: "Utilize Devise for authentication, automatically configured for your selected ORM."
