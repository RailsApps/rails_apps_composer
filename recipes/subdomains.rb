# Application template recipe for the rails_apps_composer. Check for a newer version here:
# https://github.com/RailsApps/rails_apps_composer/blob/master/recipes/subdomains.rb
# this recipe requires Mongoid and Haml (ActiveRecord and ERB verions are not implemented)

if recipes.include? 'haml'
  if recipes.include? 'mongoid'
    if recipes.include? 'rails 3.1'
      after_bundler do
        say_wizard "Subdomains recipe running 'after bundler'"
        case config['subdomain_option']
          when 'no'
            say_wizard "Subdomains recipe skipped."
          when 'one-per-user'
            # user name as a subdomain
            inject_into_file 'app/models/user.rb', :before => 'validates_uniqueness_of' do
<<-RUBY
    validates_format_of :name, with: /^[a-z0-9_]+$/, message: 'must be lowercase alphanumerics only'
    validates_length_of :name, maximum: 32, message: 'exceeds maximum of 32 characters'
    validates_exclusion_of :name, in: ['www', 'mail', 'ftp'], message: 'is not available'
RUBY
            end
            # modify db/seeds.rb
            gsub_file 'db/seeds.rb', /First User/, 'myname'
            # controller and views for the profile page
            create_file 'app/controllers/profiles_controller.rb' do
<<-RUBY
class ProfilesController < ApplicationController
  def show
    @user = User.first(conditions: { name: request.subdomain }) || not_found
  end
  
  def not_found
    raise ActionController::RoutingError.new('User Not Found')
  end
end
RUBY
            end
            # There is Haml code in this script. Changing the indentation is perilous between HAMLs.
            # We have to use single-quote-style-heredoc to avoid interpolation.
            create_file 'app/views/profiles/show.html.haml' do
<<-'HAML'
%h1 Profile
%h3= @user.name
%h3= @user.email
HAML
            end
            # implement routing constraint for subdomains
            # be sure to autoload (set config.autoload_paths in config/application.rb)
            # or require this class in the config/routes.rb file
            create_file 'lib/subdomain.rb' do
<<-RUBY
class Subdomain
  def self.matches?(request)
    case request.subdomain
    when 'www', '', nil
      false
    else
      true
    end
  end
end
RUBY
            end
            # create routes for subdomains
            gsub_file 'config/routes.rb', /root :to => "home#index"/, ''
            inject_into_file 'config/routes.rb', :after => 'resources :users, :only => :show' do <<-RUBY
  constraints(Subdomain) do
    match '/' => 'profiles#show'
  end
  root :to => "home#index"
RUBY
            end
            
            remove_file 'app/views/home/index.html.haml'
            # There is Haml code in this script. Changing the indentation is perilous between HAMLs.
            # We have to use single-quote-style-heredoc to avoid interpolation.
            create_file 'app/views/home/index.html.haml' do
<<-'HAML'
%h3 Home
- @users.each do |user|
  %br/ 
  User: #{link_to user.name, user}
  Profile: #{link_to root_url(:subdomain => user.name), root_url(:subdomain => user.name)}
HAML
            end
        end
      end
    elsif recipes.include? 'rails 3.0'
      say_wizard "Not supported for Rails version #{Rails::VERSION::STRING}. Subdomains recipe skipped."
    else
      say_wizard "Don't know what to do for Rails version #{Rails::VERSION::STRING}. Subdomains recipe skipped."
    end
  else
    say_wizard "The subdomains recipe is only implememted for Mongoid (no support for ActiveRecord)."
  end
else
  say_wizard "The subdomains recipe is only implememted for Haml (no support for ERB)."
end

__END__

name: subdomains
description: "Allow use of subdomains."
author: RailsApps

category: other
tags: [utilities, configuration]

config:
  - subdomain_option:
      type: multiple_choice
      prompt: "Would you like to add support for subdomains?"
      choices: [["No", no], ["One subdomain per user (like Basecamp)", one-per-user]]
