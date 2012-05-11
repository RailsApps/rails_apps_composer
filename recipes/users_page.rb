# Application template recipe for the rails_apps_composer. Check for a newer version here:
# https://github.com/RailsApps/rails_apps_composer/blob/master/recipes/users_page.rb

after_bundler do

  say_wizard "UsersPage recipe running 'after bundler'"

    #----------------------------------------------------------------------------
    # Create a users controller
    #----------------------------------------------------------------------------
    generate(:controller, "users show index")
    remove_file 'app/controllers/users_controller.rb'
    create_file 'app/controllers/users_controller.rb' do <<-RUBY
class UsersController < ApplicationController
  before_filter :authenticate_user!

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

end
RUBY
    end
    if recipes.include? 'authorization'
      inject_into_file 'app/controllers/users_controller.rb', "    authorize! :index, @user, :message => 'Not authorized as an administrator.'\n", :after => "def index\n"
    end
    if recipes.include? 'paginate'
      gsub_file 'app/controllers/users_controller.rb', /@users = User.all/, '@users = User.paginate(:page => params[:page])'
    end

    #----------------------------------------------------------------------------
    # Limit access to the users#index page
    #----------------------------------------------------------------------------
    if recipes.include? 'authorization'
      inject_into_file 'app/models/ability.rb', :after => "def initialize(user)\n" do <<-RUBY
    user ||= User.new # guest user (not logged in)
    if user.has_role? :admin
      can :manage, :all
    end
RUBY
      end
    end

    #----------------------------------------------------------------------------
    # Modify the routes
    #----------------------------------------------------------------------------
    # @devise_for :users@ route must be placed above @resources :users, :only => :show@.
    gsub_file 'config/routes.rb', /get \"users\/show\"/, ''
    gsub_file 'config/routes.rb', /get \"users\/index\"/, ''
    gsub_file 'config/routes.rb', /devise_for :users/ do
    <<-RUBY
devise_for :users
  resources :users, :only => [:show, :index]
RUBY
    end

    #----------------------------------------------------------------------------
    # Create a users index page
    #----------------------------------------------------------------------------
    if recipes.include? 'haml'
      remove_file 'app/views/users/index.html.haml'
      # There is Haml code in this script. Changing the indentation is perilous between HAMLs.
      # We have to use single-quote-style-heredoc to avoid interpolation.
      create_file 'app/views/users/index.html.haml' do <<-'HAML'
%h2 Users
- @users.each do |user|
  %br/
  #{link_to user.email, user} signed up #{user.created_at.to_date}
HAML
      end
      if recipes.include? 'paginate'
        append_file 'app/views/users/index.html.haml', "\n= will_paginate\n"
      end
    else
      append_file 'app/views/users/index.html.erb' do <<-ERB
<ul class="users">
  <% @users.each do |user| %>
    <li>
      <%= link_to user.name, user %> signed up <%= user.created_at.to_date %>
    </li>
  <% end %>
</ul>
ERB
      end
      if recipes.include? 'paginate'
        append_file 'app/views/users/index.html.erb', "\n<%= will_paginate %>\n"
      end
    end

    #----------------------------------------------------------------------------
    # Create a users show page
    #----------------------------------------------------------------------------
    if recipes.include? 'haml'
      remove_file 'app/views/users/show.html.haml'
      # There is Haml code in this script. Changing the indentation is perilous between HAMLs.
      # We have to use single-quote-style-heredoc to avoid interpolation.
      create_file 'app/views/users/show.html.haml' do <<-'HAML'
%p
  User: #{@user.name}
%p
  Email: #{@user.email if @user.email}
HAML
      end
    else
      append_file 'app/views/users/show.html.erb' do <<-ERB
<p>User: <%= @user.name %></p>
<p>Email: <%= @user.email if @user.email %></p>
ERB
      end
    end

    #----------------------------------------------------------------------------
    # Create a home page containing links to user show pages
    # (clobbers code from the home_page_users recipe)
    #----------------------------------------------------------------------------
    # set up the controller
    remove_file 'app/controllers/home_controller.rb'
    create_file 'app/controllers/home_controller.rb' do
    <<-RUBY
class HomeController < ApplicationController
  def index
    @users = User.all
  end
end
RUBY
    end

    # modify the home page
    if recipes.include? 'haml'
      remove_file 'app/views/home/index.html.haml'
      # There is Haml code in this script. Changing the indentation is perilous between HAMLs.
      # We have to use single-quote-style-heredoc to avoid interpolation.
      create_file 'app/views/home/index.html.haml' do
      <<-'HAML'
%h3 Home
- @users.each do |user|
  %p User: #{link_to user.name, user}
HAML
      end
    else
      remove_file 'app/views/home/index.html.erb'
      create_file 'app/views/home/index.html.erb' do <<-ERB
<h3>Home</h3>
<% @users.each do |user| %>
  <p>User: <%=link_to user.name, user %></p>
<% end %>
ERB
      end
    end

end

__END__

name: UsersPage
description: "Add a users controller and user show page with links from the home page."
author: RailsApps

run_after: [add_user]
category: other
tags: [utilities, configuration]
