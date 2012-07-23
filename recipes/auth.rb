# Application template recipe for the rails_apps_composer. Change the recipe here:
# https://github.com/RailsApps/rails_apps_composer/blob/master/recipes/auth.rb

after_bundler do
  say_wizard "recipe running after 'bundle install'"
  ### DEVISE ###
  if recipes.include? 'devise'
    # Prevent logging of password_confirmation
    gsub_file 'config/application.rb', /:password/, ':password, :password_confirmation'
    generate 'devise:install'
    generate 'devise_invitable:install' if recipes.include? 'devise-invitable'
    generate 'devise user'
    ## DEVISE AND CUCUMBER
    if recipes.include? 'cucumber'
      # Cucumber wants to test GET requests not DELETE requests for destroy_user_session_path
      # (see https://github.com/RailsApps/rails3-devise-rspec-cucumber/issues/3)
      gsub_file 'config/initializers/devise.rb', 'config.sign_out_via = :delete', 'config.sign_out_via = Rails.env.test? ? :get : :delete'
    end
    ## DEVISE MODULES
    if recipes.include? 'devise-confirmable'
      gsub_file 'app/models/user.rb', /:registerable,/, ":registerable, :confirmable,"
      gsub_file 'app/models/user.rb', /:remember_me/, ':remember_me, :confirmed_at'
      if recipes.include? 'mongoid'
        gsub_file 'app/models/user.rb', /# field :confirmation_token/, "field :confirmation_token"
        gsub_file 'app/models/user.rb', /# field :confirmed_at/, "field :confirmed_at"
        gsub_file 'app/models/user.rb', /# field :confirmation_sent_at/, "field :confirmation_sent_at"
        gsub_file 'app/models/user.rb', /# field :unconfirmed_email/, "field :unconfirmed_email"
      end
    end
    if recipes.include? 'devise-invitable'
      if recipes.include? 'mongoid'
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
    end    
  end
  ### OMNIAUTH ###
  if recipes.include? 'omniauth'
    provider = 'twitter' if recipes.include? 'twitter'
    provider = 'facebook' if recipes.include? 'facebook'
    provider = 'github' if recipes.include? 'github'
    provider = 'linkedin' if recipes.include? 'linkedin'
    provider = 'google-oauth2' if recipes.include? 'google-oauth2'
    provider = 'tumblr' if recipes.include? 'tumblr'
    # Don't use single-quote-style-heredoc: we want interpolation.
    create_file 'config/initializers/omniauth.rb' do <<-RUBY
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :#{provider}, ENV['OMNIAUTH_PROVIDER_KEY'], ENV['OMNIAUTH_PROVIDER_SECRET']
end
RUBY
    end
  end
  ### CANCAN ###
  if recipes.include? 'cancan'
    generate 'cancan:ability'
    if recipes.include? 'admin_dashboard'
      # Limit access to the users#index page
      inject_into_file 'app/models/ability.rb', :after => "def initialize(user)\n" do <<-RUBY
    user ||= User.new # guest user (not logged in)
    if user.has_role? :admin
      can :manage, :all
    end
RUBY
      end
    end
  end
  ### GIT ###
  git :add => '.' if recipes.include? 'git'
  git :commit => "-aqm 'rails_apps_composer: authentication and authorization'" if recipes.include? 'git'
end # after_bundler

__END__

name: auth
description: "Add authentication and authorization."
author: RailsApps

category: authentication
exclusive: authentication

