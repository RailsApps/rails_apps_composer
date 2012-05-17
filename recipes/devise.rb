# Application template recipe for the rails_apps_composer. Check for a newer version here:
# https://github.com/RailsApps/rails_apps_composer/blob/master/recipes/devise.rb

case config['devise']
  when 'no'
    recipes.delete('devise')
    say_wizard "Devise recipe skipped."
  when 'standard'
    gem 'devise', '>= 2.1.0'
  when 'confirmable'
    gem 'devise', '>= 2.1.0'
    recipes << 'devise-confirmable'
  when 'invitable'
    gem 'devise', '>= 2.1.0'
    gem 'devise_invitable', '>= 1.0.1'
    recipes << 'devise-confirmable'
    recipes << 'devise-invitable'
  else
    recipes.delete('devise')
    say_wizard "Devise recipe skipped."
end

if config['authorization']
  gem 'cancan', '>= 1.6.7'
  gem 'rolify', '>= 3.1.0'
  recipes << 'authorization'
end

if recipes.include? 'devise'
  after_bundler do

    say_wizard "Devise recipe running 'after bundler'"

    # Run the Devise generator
    generate 'devise:install' unless recipes.include? 'datamapper'
    generate 'devise_invitable:install' if recipes.include? 'devise-invitable'

    if recipes.include? 'mongo_mapper'
      gem 'mm-devise'
      gsub_file 'config/initializers/devise.rb', 'devise/orm/', 'devise/orm/mongo_mapper_active_model'
      generate 'mongo_mapper:devise User'
    elsif recipes.include? 'mongoid'
      # Nothing to do (Devise changes its initializer automatically when Mongoid is detected)
      # gsub_file 'config/initializers/devise.rb', 'devise/orm/active_record', 'devise/orm/mongoid'
    end

    # Prevent logging of password_confirmation
    gsub_file 'config/application.rb', /:password/, ':password, :password_confirmation'

    if recipes.include? 'cucumber'
      # Cucumber wants to test GET requests not DELETE requests for destroy_user_session_path
      # (see https://github.com/RailsApps/rails3-devise-rspec-cucumber/issues/3)
      gsub_file 'config/initializers/devise.rb', 'config.sign_out_via = :delete', 'config.sign_out_via = Rails.env.test? ? :get : :delete'
    end
    
    if config['authorization']
      inject_into_file 'app/controllers/application_controller.rb', :before => 'end' do <<-RUBY
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, :alert => exception.message
  end
RUBY
      end
    end
    
  end

  after_everything do

    say_wizard "Devise recipe running 'after everything'"

    if recipes.include? 'rspec'
      say_wizard "Copying RSpec files from the rails3-devise-rspec-cucumber examples"
      begin
        # copy all the RSpec specs files from the rails3-devise-rspec-cucumber example app
        remove_file 'spec/factories/users.rb'
        get 'https://raw.github.com/RailsApps/rails3-devise-rspec-cucumber/master/spec/factories/users.rb', 'spec/factories/users.rb'
        gsub_file 'spec/factories/users.rb', /# confirmed_at/, "confirmed_at" if recipes.include? 'devise-confirmable'
        remove_file 'spec/controllers/home_controller_spec.rb'
        remove_file 'spec/controllers/users_controller_spec.rb'
        get 'https://raw.github.com/RailsApps/rails3-devise-rspec-cucumber/master/spec/controllers/home_controller_spec.rb', 'spec/controllers/home_controller_spec.rb'
        get 'https://raw.github.com/RailsApps/rails3-devise-rspec-cucumber/master/spec/controllers/users_controller_spec.rb', 'spec/controllers/users_controller_spec.rb'
        remove_file 'spec/models/user_spec.rb'
        get 'https://raw.github.com/RailsApps/rails3-devise-rspec-cucumber/master/spec/models/user_spec.rb', 'spec/models/user_spec.rb'
      rescue OpenURI::HTTPError
        say_wizard "Unable to obtain RSpec example files from the repo"
      end
      remove_file 'spec/views/home/index.html.erb_spec.rb'
      remove_file 'spec/views/home/index.html.haml_spec.rb'
      remove_file 'spec/views/users/show.html.erb_spec.rb'
      remove_file 'spec/views/users/show.html.haml_spec.rb'
      remove_file 'spec/helpers/home_helper_spec.rb'
      remove_file 'spec/helpers/users_helper_spec.rb'
    end
    
  end
end

__END__

name: Devise
description: Utilize Devise for authentication, automatically configured for your selected ORM.
author: RailsApps

category: authentication
exclusive: authentication

config:
  - devise:
      type: multiple_choice
      prompt: Would you like to use Devise for authentication?
      choices: [["No", no], ["Devise with default modules", standard], ["Devise with Confirmable module", confirmable], ["Devise with Confirmable and Invitable modules", invitable]]
  - authorization:
      type: boolean
      prompt: Would you like to manage authorization with CanCan & Rolify?
