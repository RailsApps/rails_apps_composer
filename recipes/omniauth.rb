# Application template recipe for the rails3_devise_wizard. Check for a newer version here:
# https://github.com/fortuity/rails3_devise_wizard/blob/master/recipes/omniauth.rb

if config['omniauth']
  gem 'omniauth', '>= 0.2.4'
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

    append_file '.gitignore' do <<-TXT
\n
# keep OmniAuth service provider secrets out of the Git repo
config/initializers/omniauth.rb
TXT
    end

    route "match '/auth/failure' => 'sessions#failure'"
    route "match '/signout' => 'sessions#destroy', :as => :signout"
    route "match '/signin' => 'sessions#new', :as => :signin"
    route "match '/auth/:provider/callback' => 'sessions#create'"
    route "resources :users, :only => [ :show, :edit, :update ]"

    inject_into_file 'app/models/user.rb', :before => 'end' do <<-RUBY
\n
  def self.create_with_omniauth(auth)
    create! do |user|
      user.provider = auth['provider']
      user.uid = auth['uid']
      user.name = auth['user_info']['name'] if auth['user_info']['name'] # Twitter, Google, Yahoo, GitHub
      user.email = auth['user_info']['email'] if auth['user_info']['email'] # Google, Yahoo, GitHub
      user.name = auth['extra']['user_hash']['name'] if auth['extra']['user_hash']['name'] # Facebook
      user.email = auth['extra']['user_hash']['email'] if auth['extra']['user_hash']['email'] # Facebook
    end
  end
\n
RUBY
    end

    # We have to use single-quote-style-heredoc to avoid interpolation.
    create_file 'app/controllers/sessions_controller.rb', do <<-'RUBY'
class SessionsController < ApplicationController

  def create
    auth = request.env["omniauth.auth"]
    user = User.where(:provider => auth['provider'], 
                      :uid => auth['uid']).first || User.create_with_omniauth(auth)
    session[:user_id] = user.id
    if !user.email
      redirect_to edit_user_path(user), :alert => "Please enter your email address."
    else
      redirect_to root_url, :notice => 'Signed in!'
    end
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
    inject_into_class 'app/controllers/sessions_controller.rb', do <<-RUBY

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
\n
RUBY
    end

  end
end

__END__

name: OmniAuth
description: "Utilize OmniAuth for authentication."
author: fortuity

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
