# Application template recipe for the rails3_devise_wizard. Check for a newer version here:
# https://github.com/fortuity/rails3_devise_wizard/blob/master/recipes/mongoid.rb

gem 'bson_ext', '>= 1.3.0'
gem 'mongoid', '>= 2.0.1'

after_bundler do
  
  generate 'mongoid:config'
  
  # note: the mongoid generator automatically modifies the config/application.rb file
  # to remove the ActiveRecord dependency by commenting out "require active_record/railtie'"
  
  # remove the unnecessary 'config/database.yml' file
  remove_file 'config/database.yml'
  
end

__END__

name: Mongoid
description: "Utilize MongoDB with Mongoid as the ORM."
author: fortuity

category: persistence
exclusive: orm
tags: [orm, mongodb]

args: ["-O"]

