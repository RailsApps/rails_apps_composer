# Application template recipe for the rails_apps_composer. Check for a newer version here:
# https://github.com/RailsApps/rails_apps_composer/blob/master/recipes/omniauth.rb

if config['omniauth']
  gem 'omniauth', '>= 1.1.0'
  # for available gems, see https://github.com/intridea/omniauth/wiki/List-of-Strategies
  case config['provider']
    when 'twitter'
      gem 'omniauth-twitter'
    when 'facebook'
      gem 'omniauth-facebook'
    when 'github'
     gem 'omniauth-github'
    when 'linkedin'
      gem 'omniauth-linkedin'
    when 'google'
      gem 'omniauth-google'
    when 'tumblr'
      gem 'omniauth-tumblr'
  end
else
  recipes.delete('omniauth')
end

if config['omniauth']
  after_bundler do

    say_wizard "OmniAuth recipe running 'after bundler'"
  
    # Don't use single-quote-style-heredoc: we want interpolation.
    create_file 'config/initializers/omniauth.rb' do <<-RUBY
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :#{config['provider']}, 'KEY', 'SECRET'
end
RUBY
    end

    # add routes
    route "match '/auth/failure' => 'sessions#failure'"
    route "match '/signout' => 'sessions#destroy', :as => :signout"
    route "match '/signin' => 'sessions#new', :as => :signin"
    route "match '/auth/:provider/callback' => 'sessions#create'"
    route "resources :users, :only => [ :show, :edit, :update ]"

    # generate the user model
    generate(:model, "user provider:string uid:string name:string email:string")

    # modify the user model
    inject_into_file 'app/models/user.rb', :before => 'end' do <<-RUBY

  def self.create_with_omniauth(auth)
    create! do |user|
      user.provider = auth['provider']
      user.uid = auth['uid']
      if auth['info']
         user.name = auth['info']['name'] || ""
         user.email = auth['info']['email'] || ""
      end
    end
  end

RUBY
    end

    # We have to use single-quote-style-heredoc to avoid interpolation.
    create_file 'app/controllers/sessions_controller.rb' do <<-'RUBY'
class SessionsController < ApplicationController

  def create
    auth = request.env["omniauth.auth"]
    user = User.where(:provider => auth['provider'], 
                      :uid => auth['uid']).first || User.create_with_omniauth(auth)
    session[:user_id] = user.id
    redirect_to root_url, :notice => 'Signed in!'
  end

  def destroy
    reset_session
    redirect_to root_url, :notice => 'Signed out!'
  end

  def failure
    redirect_to root_url, :alert => "Authentication error: #{params[:message].humanize}"
  end

end
RUBY
    end

    # Don't use single-quote-style-heredoc: we want interpolation.
    inject_into_class 'app/controllers/sessions_controller.rb', 'SessionsController' do <<-RUBY

  def new
    redirect_to '/auth/#{config['provider']}'
  end

RUBY
    end

    inject_into_file 'app/controllers/application_controller.rb', :before => 'end' do <<-RUBY
  helper_method :current_user
  helper_method :user_signed_in?
  helper_method :correct_user?

  private
    def current_user
      begin
        @current_user ||= User.find(session[:user_id]) if session[:user_id]
      rescue Mongoid::Errors::DocumentNotFound
        nil
      end
    end

    def user_signed_in?
      return true if current_user
    end

    def correct_user?
      @user = User.find(params[:id])
      unless current_user == @user
        redirect_to root_url, :alert => "Access denied."
      end
    end

    def authenticate_user!
      if !current_user
        redirect_to root_url, :alert => 'You need to sign in for access to this page.'
      end
    end

RUBY
    end

  end

  after_everything do

    say_wizard "OmniAuth recipe running 'after everything'"

    if recipes.include? 'rspec'
      say_wizard "Copying RSpec files from the rails3-mongoid-omniauth examples"
      begin
        # copy all the RSpec specs files from the rails3-mongoid-omniauth example app
        # spec_helper
        remove_file 'spec/spec_helper.rb'
        get 'https://raw.github.com/RailsApps/rails3-mongoid-omniauth/master/spec/spec_helper.rb', 'spec/spec_helper.rb'
        # factories
        remove_file 'spec/factories/users.rb'
        get 'https://raw.github.com/RailsApps/rails3-mongoid-omniauth/master/spec/factories/users.rb', 'spec/factories/users.rb'
        # controllers
        get 'https://raw.github.com/RailsApps/rails3-mongoid-omniauth/master/spec/controllers/sessions_controller_spec.rb', 'spec/controllers/sessions_controller_spec.rb'
        remove_file 'spec/controllers/home_controller_spec.rb'
        remove_file 'spec/controllers/users_controller_spec.rb'
        get 'https://raw.github.com/RailsApps/rails3-mongoid-omniauth/master/spec/controllers/home_controller_spec.rb', 'spec/controllers/home_controller_spec.rb'
        get 'https://raw.github.com/RailsApps/rails3-mongoid-omniauth/master/spec/controllers/users_controller_spec.rb', 'spec/controllers/users_controller_spec.rb'
        # models
        remove_file 'spec/models/user_spec.rb'
        get 'https://raw.github.com/RailsApps/rails3-mongoid-omniauth/master/spec/models/user_spec.rb', 'spec/models/user_spec.rb'
      rescue OpenURI::HTTPError
        say_wizard "Unable to obtain RSpec example files from the repo"
      end
    end
    
  end

end

__END__

name: OmniAuth
description: "Utilize OmniAuth for authentication."
author: RailsApps

exclusive: authentication
category: authentication

config:
  - omniauth:
      type: boolean
      prompt: Would you like to use OmniAuth for authentication?
  - provider:
      type: multiple_choice
      prompt: "Which service provider will you use?"
      choices: [["Twitter", twitter], ["Facebook", facebook], ["GitHub", github], ["LinkedIn", linkedin], ["Google", google], ["Tumblr", tumblr]]
