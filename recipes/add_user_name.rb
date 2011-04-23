# Application template recipe for the rails3_devise_wizard. Check for a newer version here:
# https://github.com/fortuity/rails3_devise_wizard/blob/master/recipes/add_user_name.rb

after_bundler do
  
  say_wizard "AddUserName recipe running 'after bundler'"
  
  # Add a 'name' attribute to the User model
  if recipes.include? 'mongoid'
    gsub_file 'app/models/user.rb', /end/ do
  <<-RUBY
  field :name
  validates_presence_of :name
  validates_uniqueness_of :name, :email, :case_sensitive => false
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me
end
RUBY
    end
  else
    # for ActiveRecord
    # Devise created a Users database, we'll modify it
    generate 'migration AddNameToUsers name:string'
    # Devise created a Users model, we'll modify it
    gsub_file 'app/models/user.rb', /attr_accessible :email/, 'attr_accessible :name, :email'
    inject_into_file 'app/models/user.rb', :before => 'validates_uniqueness_of' do
      "validates_presence_of :name\n"
    end
    gsub_file 'app/models/user.rb', /validates_uniqueness_of :email/, 'validates_uniqueness_of :name, :email'
  end

  if recipes.include? 'devise'
    unless recipes.include? 'haml'
      
      # Generate Devise views (unless you are using Haml)
      run 'rails generate devise:views'
      
      # Modify Devise views to add 'name'
      inject_into_file "app/views/devise/registrations/edit.html.erb", :after => "<%= devise_error_messages! %>\n" do
      <<-ERB
    <p><%= f.label :name %><br />
    <%= f.text_field :name %></p>
ERB
      end

      inject_into_file "app/views/devise/registrations/new.html.erb", :after => "<%= devise_error_messages! %>\n" do
      <<-ERB
    <p><%= f.label :name %><br />
    <%= f.text_field :name %></p>
ERB
      end

    else

      # copy Haml versions of modified Devise views
      inside 'app/views/devise/registrations' do
        get 'https://github.com/fortuity/rails3-application-templates/raw/master/files/rails3-mongoid-devise/app/views/devise/registrations/edit.html.haml', 'edit.html.haml'
        get 'https://github.com/fortuity/rails3-application-templates/raw/master/files/rails3-mongoid-devise/app/views/devise/registrations/new.html.haml', 'new.html.haml'
      end

    end

  end

end

__END__

name: AddUserName
description: "Modify the default Devise configuration to add a 'name' attribute for all users."
author: fortuity

requires: [devise]
category: other
tags: [utilities, configuration]