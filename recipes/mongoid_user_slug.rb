# Application template recipe for the rails_apps_composer. Check for a newer version here:
# https://github.com/RailsApps/rails_apps_composer/blob/master/recipes/ban_spiders.rb

gem 'mongoid_slug'

say_wizard "MongoidUserSlug recipe running 'after bundler'" 
after_bundler do
  gsub_file 'app/models/user.rb', /include Mongoid::Document/ do <<-RUBY
include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slug
RUBY
  end

  gsub_file 'app/models/user.rb', /field :name/ do <<-RUBY
field :name
  slug :name
RUBY
  end
  
  gsub_file 'app/controllers/users_controller.rb', /User.find/, "User.find_by_slug"

  gsub_file 'spec/controllers/users_controller_spec.rb', /:id => @user.id/, ":id => @user.slug"

end


__END__

category: other
name: MongoidUserSlug
description: "Adds a slug to a mongoid user model"
author: vegetables
requires: [mongoid, devise, users_page]