# Application template recipe for the rails_apps_composer. Change the recipe here:
# https://github.com/RailsApps/rails_apps_composer/blob/master/recipes/models.rb

after_bundler do
  say_wizard "recipe running after 'bundle install'"
  ### DEVISE ###
  if prefer :authentication, 'devise'
    # prevent logging of password_confirmation
    gsub_file 'config/application.rb', /:password/, ':password, :password_confirmation'
    generate 'devise:install'
    generate 'devise_invitable:install' if prefer :devise_modules, 'invitable'
    generate 'devise user' # create the User model
    if prefer :orm, 'mongoid'
      ## DEVISE AND MONGOID
      copy_from_repo 'app/models/user.rb', :repo => 'https://raw.github.com/RailsApps/rails3-mongoid-devise/master/'
      if (prefer :devise_modules, 'confirmable') || (prefer :devise_modules, 'invitable')
        gsub_file 'app/models/user.rb', /:registerable,/, ":registerable, :confirmable,"
        gsub_file 'app/models/user.rb', /# field :confirmation_token/, "field :confirmation_token"
        gsub_file 'app/models/user.rb', /# field :confirmed_at/, "field :confirmed_at"
        gsub_file 'app/models/user.rb', /# field :confirmation_sent_at/, "field :confirmation_sent_at"
        gsub_file 'app/models/user.rb', /# field :unconfirmed_email/, "field :unconfirmed_email"
      end
      if (prefer :devise_modules, 'invitable')
        gsub_file 'app/models/user.rb', /\bend\s*\Z/ do
  <<-RUBY
  #invitable
  field :invitation_token, :type => String
  field :invitation_sent_at, :type => Time
  field :invitation_accepted_at, :type => Time
  field :invitation_limit, :type => Integer
  field :invited_by_id, :type => String
  field :invited_by_type, :type => String
end
RUBY
        end
      end
    else
      ## DEVISE AND ACTIVE RECORD
      generate 'migration AddNameToUsers name:string'
      copy_from_repo 'app/models/user.rb', :repo => 'https://raw.github.com/RailsApps/rails3-devise-rspec-cucumber/master/'
      if (prefer :devise_modules, 'confirmable') || (prefer :devise_modules, 'invitable')
        gsub_file 'app/models/user.rb', /:registerable,/, ":registerable, :confirmable,"
        generate 'migration AddConfirmableToUsers confirmation_token:string confirmed_at:datetime confirmation_sent_at:datetime unconfirmed_email:string'
      end
    end
    ## DEVISE AND CUCUMBER
    if prefer :integration, 'cucumber'
      # Cucumber wants to test GET requests not DELETE requests for destroy_user_session_path
      # (see https://github.com/RailsApps/rails3-devise-rspec-cucumber/issues/3)
      gsub_file 'config/initializers/devise.rb', 'config.sign_out_via = :delete', 'config.sign_out_via = Rails.env.test? ? :get : :delete'
    end
  end
  ### OMNIAUTH ###
  if prefer :authentication, 'omniauth'
    repo = 'https://raw.github.com/RailsApps/rails3-mongoid-omniauth/master/'
    copy_from_repo 'config/initializers/omniauth.rb', :repo => repo
    gsub_file 'config/initializers/omniauth.rb', /twitter/, prefs[:omniauth_provider] unless prefer :omniauth_provider, 'twitter'
    generate 'model User name:string email:string provider:string uid:string' unless prefer :orm, 'mongoid'
    run 'bundle exec rake db:migrate' unless prefer :orm, 'mongoid' 
    copy_from_repo 'app/models/user.rb', :repo => repo  # copy the User model (Mongoid version)
    unless prefer :orm, 'mongoid'
      ## OMNIAUTH AND ACTIVE RECORD
      gsub_file 'app/models/user.rb', /class User/, 'class User < ActiveRecord::Base'
      gsub_file 'app/models/user.rb', /^\s*include Mongoid::Document\n/, ''
      gsub_file 'app/models/user.rb', /^\s*field.*\n/, ''
      gsub_file 'app/models/user.rb', /^\s*# run 'rake db:mongoid:create_indexes' to create indexes\n/, ''
      gsub_file 'app/models/user.rb', /^\s*index\(\{ email: 1 \}, \{ unique: true, background: true \}\)\n/, ''
    end
  end
  ### SUBDOMAINS ###
  copy_from_repo 'app/models/user.rb', :repo => 'https://raw.github.com/RailsApps/rails3-subdomains/master/' if prefer :starter_app, 'subdomains_app'
  ### AUTHORIZATION ###
  if prefer :authorization, 'cancan'
    generate 'cancan:ability'
    if prefer :starter_app, 'admin_app' 
      # Limit access to the users#index page
      copy_from_repo 'app/models/ability.rb', :repo => 'https://raw.github.com/RailsApps/rails3-bootstrap-devise-cancan/master/'
      # allow an admin to update roles
      insert_into_file 'app/models/user.rb', "  attr_accessible :role_ids, :as => :admin\n", :before => "  attr_accessible"
    end
    unless prefer :orm, 'mongoid'
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
  end
  ### GIT ###
  git :add => '-A' if prefer :git, true
  git :commit => '-qm "rails_apps_composer: models"' if prefer :git, true
end # after_bundler

__END__

name: models
description: "Add models needed for starter apps."
author: RailsApps

requires: [setup, gems]
run_after: [setup, gems]
category: mvc
