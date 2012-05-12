# Application template recipe for the rails_apps_composer. Check for a newer version here:
# https://github.com/RailsApps/rails_apps_composer/blob/master/recipes/omniauth_email.rb

after_bundler do

  say_wizard "OmniAuthEmail recipe running 'after bundler'"

    #----------------------------------------------------------------------------
    # Modify a users controller
    #----------------------------------------------------------------------------
    inject_into_file 'app/controllers/users_controller.rb', :after => "before_filter :authenticate_user!\n" do <<-RUBY
  before_filter :correct_user?
RUBY
    end
    
    inject_into_file 'app/controllers/users_controller.rb', :before => 'def show' do <<-RUBY
  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      redirect_to @user
    else
      render :edit
    end
  end
\n
RUBY
    end

    #----------------------------------------------------------------------------
    # Create a users edit page
    #----------------------------------------------------------------------------
    if recipes.include? 'haml'
      remove_file 'app/views/users/edit.html.haml'
      # There is Haml code in this script. Changing the indentation is perilous between HAMLs.
      # We have to use single-quote-style-heredoc to avoid interpolation.
      create_file 'app/views/users/edit.html.haml' do <<-'HAML'
= form_for(@user) do |f|
  = f.label :email
  = f.text_field :email
  %br/
  = f.submit "Sign in"
HAML
      end
    else
      create_file 'app/views/users/edit.html.erb' do <<-ERB
<%= form_for(@user) do |f| %>
  <%= f.label :email %>
  <%= f.text_field :email %>
  <br />
  <%= f.submit "Sign in" %>
<% end %>
ERB
      end
    end

    #----------------------------------------------------------------------------
    # Modify a Sessions controller
    #----------------------------------------------------------------------------
    gsub_file 'app/controllers/sessions_controller.rb', /redirect_to root_url, :notice => 'Signed in!'/ do
  <<-RUBY
if user.email.blank?
      redirect_to edit_user_path(user), :alert => "Please enter your email address."
    else
      redirect_to root_url, :notice => 'Signed in!'
    end
RUBY
    end

end

__END__

name: OmniAuthEmail
description: "Request a user's email address for an OmniAuth example app."
author: RailsApps

category: other
tags: [utilities, configuration]
