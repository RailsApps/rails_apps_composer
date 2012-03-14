# Application template recipe for the rails_apps_composer. Check for a newer version here:
# https://github.com/RailsApps/rails_apps_composer/blob/master/recipes/add_user.rb

after_bundler do
  
  say_wizard "AddUser recipe running 'after bundler'"
  
  if recipes.include? 'omniauth'
    generate(:model, "user provider:string uid:string name:string email:string")
    gsub_file 'app/models/user.rb', /end/ do
<<-RUBY
  attr_accessible :provider, :uid, :name, :email
end
RUBY
    end
  end

  if recipes.include? 'devise'

    # Generate models and routes for a User
    generate 'devise user'

    # Add a 'name' attribute to the User model
    if recipes.include? 'mongoid'
      # for mongoid
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
      if recipes.include? 'devise-confirmable'
        generate 'migration AddConfirmableToUsers confirmation_token:string confirmed_at:datetime confirmation_sent_at:datetime unconfirmed_email:string'
      end
      # Devise created a Users model, we'll modify it
      gsub_file 'app/models/user.rb', /attr_accessible :email/, 'attr_accessible :name, :email'
      inject_into_file 'app/models/user.rb', :before => 'validates_uniqueness_of' do
        "validates_presence_of :name\n"
      end
      gsub_file 'app/models/user.rb', /validates_uniqueness_of :email/, 'validates_uniqueness_of :name, :email'
    end

    # needed for both mongoid and ActiveRecord
    if recipes.include? 'devise-confirmable'
      gsub_file 'app/models/user.rb', /:registerable,/, ":registerable, :confirmable,"
      gsub_file 'app/models/user.rb', /:remember_me/, ':remember_me, :confirmed_at'
    end

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
      inside 'app/views/devise' do
        get 'https://raw.github.com/RailsApps/rails3-application-templates/master/files/rails3-mongoid-devise/app/views/devise/_links.erb', '_links.erb'
      end
      inside 'app/views/devise/registrations' do
        get 'https://raw.github.com/RailsApps/rails3-application-templates/master/files/rails3-mongoid-devise/app/views/devise/registrations/edit.html.haml', 'edit.html.haml'
        get 'https://raw.github.com/RailsApps/rails3-application-templates/master/files/rails3-mongoid-devise/app/views/devise/registrations/new.html.haml', 'new.html.haml'
      end

    end

  end

end

__END__

name: AddUser
description: "Add a User model including 'name' and 'email' attributes."
author: RailsApps

run_after: [devise, omniauth]
category: other
tags: [utilities, configuration]
