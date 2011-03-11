require 'rails_wizard/recipe'

module RailsWizard
  module Recipes
    class Devise < RailsWizard::Recipe
      name "Devise"
      category "authentication"
      description "Utilize Devise for authentication, automatically configured for your selected ORM."
    end
  end
end

__END__

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
