# Application template recipe for the rails_apps_composer. Check for a newer version here:
# https://github.com/RailsApps/rails_apps_composer/blob/master/recipes/mongoid.rb

if config['mongoid']
  if recipes.include? 'rails 3.0'
    # for Rails 3.0, use only gem versions we know that work
    say_wizard "REMINDER: When creating a Rails app using Mongoid..."
    say_wizard "you should add the '-O' flag to 'rails new'"
    gem 'bson_ext', '1.3.1'
    gem 'mongoid', '2.0.2'
  else
    # for Rails 3.1+, use optimistic versioning for gems
    gem 'bson_ext', '>= 1.3.1'
    gem 'mongoid', '>= 2.1.5'
  end
else
  recipes.delete('mongoid')
end

if config['mongoid']
  after_bundler do
    say_wizard "Mongoid recipe running 'after bundler'"
    # note: the mongoid generator automatically modifies the config/application.rb file
    # to remove the ActiveRecord dependency by commenting out "require active_record/railtie'"
    generate 'mongoid:config'
    # remove the unnecessary 'config/database.yml' file
    remove_file 'config/database.yml'
  end
end

__END__

name: Mongoid
description: "Use Mongoid to connect to a MongoDB database."
author: RailsApps

category: persistence
exclusive: orm
tags: [orm, mongodb]

args: ["-O"]

config:
  - mongoid:
      type: boolean
      prompt: Would you like to use Mongoid to connect to a MongoDB database?