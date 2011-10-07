# Application template recipe for the rails_apps_composer. Check for a newer version here:
# https://github.com/RailsApps/rails_apps_composer/blob/master/recipes/omniauth.rb

if config['omniauth']
  if recipes.include? 'rails 3.0'
    # for Rails 3.0, use only gem versions we know that work
    gem 'omniauth', '0.2.6'
  else
    # for Rails 3.1+, use optimistic versioning for gems
    gem 'omniauth', '>= 0.3.0'
  end
else
  recipes.delete('omniauth')
end

if config['omniauth']
  after_bundler do

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

    # add a user model (unless another recipe did so already)
    unless recipes.include? 'add_user'
      generate(:model, "user provider:string uid:string name:string email:string")
      gsub_file 'app/models/user.rb', /end/ do
<<-RUBY
  attr_accessible :provider, :uid, :name, :email
end
RUBY
      end
    end

    # modify the user model
    inject_into_file 'app/models/user.rb', :before => 'end' do <<-RUBY

  def self.create_with_omniauth(auth)
    create! do |user|
      user.provider = auth['provider']
      user.uid = auth['uid']
      if auth['user_info']
        user.name = auth['user_info']['name'] if auth['user_info']['name'] # Twitter, Google, Yahoo, GitHub
        user.email = auth['user_info']['email'] if auth['user_info']['email'] # Google, Yahoo, GitHub
      end
      if auth['extra'] && auth['extra']['user_hash']
        user.name = auth['extra']['user_hash']['name'] if auth['extra']['user_hash']['name'] # Facebook
        user.email = auth['extra']['user_hash']['email'] if auth['extra']['user_hash']['email'] # Facebook
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
    session[:user_id] = nil
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
      choices: [["Twitter", twitter], ["Facebook", facebook], ["GitHub", github], ["LinkedIn", linked_in], ["Other", provider]]
