# Application template recipe for the rails_apps_composer. Change the recipe here:
# https://github.com/RailsApps/rails_apps_composer/blob/master/recipes/models.rb

after_bundler do
  say_wizard "recipe running after 'bundle install'"
  ### DEVISE ###
  if recipes.include? 'devise'
    if recipes.include? 'mongoid'
      if recipes.include? 'devise-confirmable'
        raise StandardError.new "Sorry. An example app using MongoDB and devise-confirmable is not available."
      end
      copy_from_repo 'app/models/user.rb', :repo => 'https://raw.github.com/RailsApps/rails3-mongoid-devise/master/' if recipes.include? 'mongoid'
    else
      generate 'migration AddNameToUsers name:string'
      if recipes.include? 'devise-confirmable'
        generate 'migration AddConfirmableToUsers confirmation_token:string confirmed_at:datetime confirmation_sent_at:datetime unconfirmed_email:string'
      end
      copy_from_repo 'app/models/user.rb', :repo => 'https://raw.github.com/RailsApps/rails3-devise-rspec-cucumber/master/'
    end
  end
  ### OMNIAUTH ###
  if recipes.include? 'omniauth'
    if recipes.include? 'mongoid'
      copy_from_repo 'app/models/user.rb', :repo => 'https://raw.github.com/RailsApps/rails3-mongoid-omniauth/master/'
    else
      generate 'model User name:string email:string provider:string uid:string'
      run 'bundle exec rake db:migrate'
      copy_from_repo 'app/models/user.rb', :repo => 'https://raw.github.com/RailsApps/rails3-mongoid-omniauth/master/'
      gsub_file 'app/models/user.rb', /class User/, 'class User < ActiveRecord::Base'
      gsub_file 'app/models/user.rb', /^\s*include Mongoid::Document\n/, ''
      gsub_file 'app/models/user.rb', /^\s*field.*\n/, ''
      gsub_file 'app/models/user.rb', /^\s*# run 'rake db:mongoid:create_indexes' to create indexes\n/, ''
      gsub_file 'app/models/user.rb', /^\s*index\(\{ email: 1 \}, \{ unique: true, background: true \}\)\n/, ''
    end
  end
  ### SUBDOMAINS ###
  copy_from_repo 'app/models/user.rb', :repo => 'https://raw.github.com/RailsApps/rails3-subdomains/master/' if recipes.include? 'subdomains'
  ### AUTHORIZATION (insert 'rolify' after User model is created) ###
  unless recipes.include? 'mongoid'
    generate 'rolify:role Role User'
  else
    generate 'rolify:role Role User mongoid'
  	# correct the generation of rolify 3.1 with mongoid
  	# the call to `rolify` should be *after* the inclusion of mongoid
  	# (see https://github.com/EppO/rolify/issues/61)
  	# This isn't needed for rolify>=3.2.0.beta4, but should cause no harm
  	gsub_file 'app/models/user.rb',
  		  /^\s*(rolify.*?)$\s*(include Mongoid::Document.*?)$/,
  		  "  \\2\n  extend Rolify\n  \\1\n"
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
