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
    
    if recipes.include? 'authorization'
      # create'app/models/ability.rb'
      generate 'cancan:ability'
      # create 'app/models/role.rb'
      # create 'config/initializers/rolify.rb'
      # create 'db/migrate/...rolify_create_roles.rb'
      # insert 'rolify' method in 'app/models/users.rb'
      if recipes.include? 'mongoid'
        generate 'rolify:role Role User mongoid'
      else
        generate 'rolify:role Role User'
      end
    end

    # Add a 'name' attribute to the User model
    if recipes.include? 'mongoid'
      # for mongoid
      gsub_file 'app/models/user.rb', /end/ do
  <<-RUBY
  # run 'rake db:mongoid:create_indexes' to create indexes
  index :email, :unique => true
  field :name
  validates_presence_of :name
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
      gsub_file 'app/models/user.rb', /# attr_accessible :title, :body/, ''
    end

    # needed for both mongoid and ActiveRecord
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
        gsub_file 'app/models/user.rb', /end/ do
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
      get 'https://raw.github.com/RailsApps/rails3-application-templates/master/files/devise-views-haml/app/views/devise/shared/_links.html.haml', 'app/views/devise/shared/_links.html.haml'
      get 'https://raw.github.com/RailsApps/rails3-application-templates/master/files/devise-views-haml/app/views/devise/registrations/edit.html.haml', 'app/views/devise/registrations/edit.html.haml'
      get 'https://raw.github.com/RailsApps/rails3-application-templates/master/files/devise-views-haml/app/views/devise/registrations/new.html.haml', 'app/views/devise/registrations/new.html.haml'
    end

  end

end

__END__

name: AddUser
description: "Add a User model including 'name' and 'email' attributes."
author: RailsApps

run_after: [devise]
category: other
tags: [utilities, configuration]
