# Application template recipe for the rails_apps_composer. Change the recipe here:
# https://github.com/RailsApps/rails_apps_composer/blob/master/recipes/models.rb

after_bundler do
  say_wizard "recipe running after 'bundle install'"
  ### DEVISE ###
  ## User model was already generated in the 'auth' recipe
  if recipes.include? 'devise'
    # Add a 'name' attribute to the User model
    ## MONGOID
    if recipes.include? 'mongoid'
      # include timestamps to avoid special casing views for Mongoid
      gsub_file 'app/models/user.rb',
        /include Mongoid::Document$/,
        "\\0\n  include Mongoid::Timestamps\n"
      # for mongoid
      gsub_file 'app/models/user.rb', /\bend\s*\Z/ do
  <<-RUBY
  # run 'rake db:mongoid:create_indexes' to create indexes
  index({ email: 1 }, { unique: true, background: true })
  field :name, :type => String
  validates_presence_of :name
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me, :created_at, :updated_at
end
RUBY
      end
    ## ACTIVERECORD
    else
      # Devise created a Users database, we'll modify it
      generate 'migration AddNameToUsers name:string'
      if recipes.include? 'devise-confirmable'
        generate 'migration AddConfirmableToUsers confirmation_token:string confirmed_at:datetime confirmation_sent_at:datetime unconfirmed_email:string'
      end
      # Devise created a Users model, we'll modify it
      gsub_file 'app/models/user.rb', /attr_accessible :email/, 'attr_accessible :name, :email'
      inject_into_file 'app/models/user.rb', :before => 'validates_uniqueness_of' do
        "validates_presence_of :name\n"
      end
      gsub_file 'app/models/user.rb', /validates_uniqueness_of :email/, 'validates_uniqueness_of :name, :email'
      gsub_file 'app/models/user.rb', /# attr_accessible :title, :body/, ''
    end
  end
  ### OMNIAUTH ###
  if recipes.include? 'omniauth'
    copy_from_repo 'app/models/user.rb', 'https://raw.github.com/RailsApps/rails3-mongoid-omniauth/master/'
  end
  ### GIT ###
  git :add => '.' if recipes.include? 'git'
  git :commit => "-aqm 'rails_apps_composer: models'" if recipes.include? 'git'
end # after_bundler

__END__

name: models
description: "Add models needed for starter apps."
author: RailsApps

run_after: [auth]
category: other
tags: [utilities, configuration]
