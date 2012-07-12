# Application template recipe for the rails_apps_composer. Check for a newer version here:
# https://github.com/RailsApps/rails_apps_composer/blob/master/recipes/prelaunch_signup.rb

@recipes = ["haml", "rspec", "cucumber", "action_mailer", "devise", "add_user", 
  "home_page", "seed_database", "users_page", "html5", "simple_form", 
  "cleanup", "extras", "git"]
  
# >-------------------------------[ Create an Initializer File ]--------------------------------<
create_file 'config/initializers/prelaunch-signup.rb' do <<-RUBY
# change to "true" (and restart) when you want visitors to sign up without an invitation
Rails.configuration.launched = false
RUBY
end

# >---------------------------------[ HAML ]----------------------------------<
gem 'haml', '>= 3.1.6'
gem 'haml-rails', '>= 0.3.4', :group => :development

# >---------------------------------[ RSpec ]---------------------------------<

gem 'rspec-rails', '>= 2.11.0', :group => [:development, :test]
gem 'factory_girl_rails', '>= 3.5.0', :group => [:development, :test]
# add a collection of RSpec matchers and Cucumber steps to make testing email easy
gem 'email_spec', '>= 1.2.1', :group => :test
create_file 'features/support/email_spec.rb' do <<-RUBY
require 'email_spec/cucumber'
RUBY
end

after_bundler do
  say_wizard "RSpec recipe running 'after bundler'"
  generate 'rspec:install'
  generate 'email_spec:steps'
  inject_into_file 'spec/spec_helper.rb', "require 'email_spec'\n", :after => "require 'rspec/rails'\n"
  inject_into_file 'spec/spec_helper.rb', :after => "RSpec.configure do |config|\n" do <<-RUBY
  config.include(EmailSpec::Helpers)
  config.include(EmailSpec::Matchers)
RUBY
  end
  say_wizard "Removing test folder (not needed for RSpec)"
  run 'rm -rf test/'
  inject_into_file 'config/application.rb', :after => "Rails::Application\n" do <<-RUBY

    # don't generate RSpec tests for views and helpers
    config.generators do |g|
      g.view_specs false
      g.helper_specs false
    end

RUBY
  end
  if recipes.include? 'devise'
    # add Devise test helpers
    create_file 'spec/support/devise.rb' do
      <<-RUBY
RSpec.configure do |config|
  config.include Devise::TestHelpers, :type => :controller
end
RUBY
    end
  end
end
after_everything do
  say_wizard "Copying RSpec files from the rails-prelaunch-signup example app"
  begin
    remove_file 'spec/factories/users.rb'
    get 'https://raw.github.com/RailsApps/rails-prelaunch-signup/master/spec/factories/users.rb', 'spec/factories/users.rb'
    gsub_file 'spec/factories/users.rb', /# confirmed_at/, "confirmed_at"
    remove_file 'spec/controllers/home_controller_spec.rb'
    remove_file 'spec/controllers/users_controller_spec.rb'
    get 'https://raw.github.com/RailsApps/rails-prelaunch-signup/master/spec/controllers/home_controller_spec.rb', 'spec/controllers/home_controller_spec.rb'
    get 'https://raw.github.com/RailsApps/rails-prelaunch-signup/master/spec/controllers/users_controller_spec.rb', 'spec/controllers/users_controller_spec.rb'
    remove_file 'spec/models/user_spec.rb'
    get 'https://raw.github.com/RailsApps/rails-prelaunch-signup/master/spec/models/user_spec.rb', 'spec/models/user_spec.rb'
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

# >-------------------------------[ Cucumber ]--------------------------------<
gem 'cucumber-rails', '>= 1.3.0', :group => :test, :require => false
gem 'capybara', '>= 1.1.2', :group => :test
gem 'database_cleaner', '>= 0.8.0', :group => :test
gem 'launchy', '>= 2.1.0', :group => :test

after_bundler do
  say_wizard "Cucumber recipe running 'after bundler'"
  generate "cucumber:install --capybara#{' --rspec' if recipes.include?('rspec')}#{' -D' if recipes.include?('mongoid')}"
  # make it easy to run Cucumber for single features without adding "--require features" to the command line
  gsub_file 'config/cucumber.yml', /std_opts = "/, 'std_opts = "-r features/support/ -r features/step_definitions '
end

after_bundler do
  say_wizard "Copying Cucumber scenarios from the rails-prelaunch-signup example app"
  begin
    get 'https://raw.github.com/RailsApps/rails-prelaunch-signup/master/features/admin/send_invitations.feature', 'features/admin/send_invitations.feature'
    get 'https://raw.github.com/RailsApps/rails-prelaunch-signup/master/features/admin/view_progress.feature', 'features/admin/view_progress.feature'
    get 'https://raw.github.com/RailsApps/rails-prelaunch-signup/master/features/step_definitions/admin_steps.rb', 'features/step_definitions/admin_steps.rb'
    get 'https://raw.github.com/RailsApps/rails-prelaunch-signup/master/features/step_definitions/email_steps.rb', 'features/step_definitions/email_steps.rb'
    get 'https://raw.github.com/RailsApps/rails-prelaunch-signup/master/features/step_definitions/user_steps.rb', 'features/step_definitions/user_steps.rb'
    get 'https://raw.github.com/RailsApps/rails-prelaunch-signup/master/features/step_definitions/visitor_steps.rb', 'features/step_definitions/visitor_steps.rb'
    remove_file 'features/support/paths.rb'
    get 'https://raw.github.com/RailsApps/rails-prelaunch-signup/master/features/support/paths.rb', 'features/support/paths.rb'
    get 'https://raw.github.com/RailsApps/rails-prelaunch-signup/master/features/users/sign_in.feature', 'features/users/sign_in.feature'
    get 'https://raw.github.com/RailsApps/rails-prelaunch-signup/master/features/users/sign_out.feature', 'features/users/sign_out.feature'
    get 'https://raw.github.com/RailsApps/rails-prelaunch-signup/master/features/users/sign_up.feature', 'features/users/sign_up.feature'
    get 'https://raw.github.com/RailsApps/rails-prelaunch-signup/master/features/users/user_edit.feature', 'features/users/user_edit.feature'
    get 'https://raw.github.com/RailsApps/rails-prelaunch-signup/master/features/users/user_show.feature', 'features/users/user_show.feature'
    get 'https://raw.github.com/RailsApps/rails-prelaunch-signup/master/features/visitors/request_invitation.feature', 'features/visitors/request_invitation.feature'
    # thank you page for testing registrations
    get 'https://raw.github.com/RailsApps/rails-prelaunch-signup/master/public/thankyou.html', 'public/thankyou.html'
  rescue OpenURI::HTTPError
    say_wizard "Unable to obtain Cucumber example files from the repo"
  end
end 

# >-----------------------------[ ActionMailer ]------------------------------<
case config['mailer']
  when 'smtp'
    recipes << 'smtp'
  when 'gmail'
    recipes << 'gmail'
  when 'sendgrid'
    gem 'sendgrid'
    recipes << 'sendgrid'
  when 'mandrill'
    gem 'hominid'
    recipes << 'mandrill'
end

after_bundler do
  ### modifying environment configuration files for ActionMailer
  say_wizard "ActionMailer recipe running 'after bundler'"
  ### development environment
  gsub_file 'config/environments/development.rb', /# Don't care if the mailer can't send/, '# ActionMailer Config'
  gsub_file 'config/environments/development.rb', /config.action_mailer.raise_delivery_errors = false/ do
  <<-RUBY
config.action_mailer.default_url_options = { :host => 'localhost:3000' }
  config.action_mailer.delivery_method = :smtp
  # change to true to allow email to be sent during development
  config.action_mailer.perform_deliveries = false
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.default :charset => "utf-8"
RUBY
  end
  ### test environment
  inject_into_file 'config/environments/test.rb', :before => "\nend" do 
  <<-RUBY
\n  
  # ActionMailer Config
  config.action_mailer.default_url_options = { :host => 'example.com' }
RUBY
  end
  ### production environment
  gsub_file 'config/environments/production.rb', /config.active_support.deprecation = :notify/ do
  <<-RUBY
config.active_support.deprecation = :notify

  config.action_mailer.default_url_options = { :host => 'example.com' }
  # ActionMailer Config
  # Setup for production - deliveries, no errors raised
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.perform_deliveries = true
  config.action_mailer.raise_delivery_errors = false
  config.action_mailer.default :charset => "utf-8"
RUBY
  end
  ### modifying environment configuration files to send email using a GMail account
  if recipes.include? 'gmail'
    gmail_configuration_text = <<-TEXT
\n
  config.action_mailer.smtp_settings = {
    address: "smtp.gmail.com",
    port: 587,
    domain: "example.com",
    authentication: "plain",
    enable_starttls_auto: true,
    user_name: ENV["GMAIL_USERNAME"],
    password: ENV["GMAIL_PASSWORD"]
  }
TEXT
    say_wizard gmail_configuration_text
    inject_into_file 'config/environments/development.rb', gmail_configuration_text, :after => 'config.action_mailer.default :charset => "utf-8"'
    inject_into_file 'config/environments/production.rb', gmail_configuration_text, :after => 'config.action_mailer.default :charset => "utf-8"'
  end
  ### modifying environment configuration files to send email using a SendGrid account
  if recipes.include? 'sendgrid'
    sendgrid_configuration_text = <<-TEXT
\n
  config.action_mailer.smtp_settings = {
    address: "smtp.sendgrid.net",
    port: 25,
    domain: "example.com",
    authentication: "plain",
    user_name: ENV["SENDGRID_USERNAME"],
    password: ENV["SENDGRID_PASSWORD"]
  }
TEXT
    say_wizard gmail_configuration_text
    inject_into_file 'config/environments/development.rb', sendgrid_configuration_text, :after => 'config.action_mailer.default :charset => "utf-8"'
    inject_into_file 'config/environments/production.rb', sendgrid_configuration_text, :after => 'config.action_mailer.default :charset => "utf-8"'
  end
    ### modifying environment configuration files to send email using a Mandrill account
    if recipes.include? 'mandrill'
      mandrill_configuration_text = <<-TEXT
  \n
    config.action_mailer.smtp_settings = {
      :address   => "smtp.mandrillapp.com",
      :port      => 25,
      :user_name => ENV["MANDRILL_USERNAME"],
      :password  => ENV["MANDRILL_API_KEY"]
    }
  TEXT
      say_wizard gmail_configuration_text
      inject_into_file 'config/environments/development.rb', mandrill_configuration_text, :after => 'config.action_mailer.default :charset => "utf-8"'
      inject_into_file 'config/environments/production.rb', mandrill_configuration_text, :after => 'config.action_mailer.default :charset => "utf-8"'
    end
end

# >--------------------------------[ Devise ]---------------------------------<
gem 'devise', '>= 2.1.2'
gem 'devise_invitable', '>= 1.0.2'
recipes << 'devise-confirmable'
recipes << 'devise-invitable'
gem 'cancan', '>= 1.6.8'
gem 'rolify', '>= 3.1.0'
recipes << 'authorization'

after_bundler do
  say_wizard "Devise recipe running 'after bundler'"
  # Run the Devise generator
  generate 'devise:install' unless recipes.include? 'datamapper'
  generate 'devise_invitable:install' if recipes.include? 'devise-invitable'
  # Prevent logging of password_confirmation
  gsub_file 'config/application.rb', /:password/, ':password, :password_confirmation'
  if recipes.include? 'cucumber'
    # Cucumber wants to test GET requests not DELETE requests for destroy_user_session_path
    # (see https://github.com/RailsApps/rails3-devise-rspec-cucumber/issues/3)
    gsub_file 'config/initializers/devise.rb', 'config.sign_out_via = :delete', 'config.sign_out_via = Rails.env.test? ? :get : :delete'
  end
  if recipes.include? 'authorization'
    inject_into_file 'app/controllers/application_controller.rb', :before => 'end' do <<-RUBY
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, :alert => exception.message
  end
RUBY
    end
  end
end

# >--------------------------------[ AddUser ]--------------------------------<
after_bundler do
  say_wizard "AddUser recipe running 'after bundler'"
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
      generate 'rolify:role Role User'
    end
    # Add a 'name' attribute to the User model
    # Devise created a Users database, we'll modify it
    generate 'migration AddNameToUsers name:string'
    if recipes.include? 'devise-confirmable'
      generate 'migration AddConfirmableToUsers confirmation_token:string confirmed_at:datetime confirmation_sent_at:datetime unconfirmed_email:string'
    end
    # Devise created a Users model, we'll replace it
    remove_file 'app/models/user.rb'
    get 'https://raw.github.com/RailsApps/rails-prelaunch-signup/master/app/models/user.rb', 'app/models/user.rb'
    # copy Haml versions of modified Devise views (plus a partial for the 'thank you' message)
    remove_file 'app/views/devise/shared/_links.html.haml'
    get 'https://raw.github.com/RailsApps/rails-prelaunch-signup/master/app/views/devise/shared/_links.html.haml', 'app/views/devise/shared/_links.html.haml'
    remove_file 'app/views/devise/registrations/edit.html.haml'
    get 'https://raw.github.com/RailsApps/rails-prelaunch-signup/master/app/views/devise/registrations/edit.html.haml', 'app/views/devise/registrations/edit.html.haml'
    remove_file 'app/views/devise/registrations/new.html.haml'
    get 'https://raw.github.com/RailsApps/rails-prelaunch-signup/master/app/views/devise/registrations/new.html.haml', 'app/views/devise/registrations/new.html.haml'
    remove_file 'app/views/devise/registrations/_thankyou.html.haml'
    get 'https://raw.github.com/RailsApps/rails-prelaunch-signup/master/app/views/devise/registrations/_thankyou.html.haml', 'app/views/devise/registrations/_thankyou.html.haml'
    remove_file 'app/views/devise/confirmations/show.html.haml'
    get 'https://raw.github.com/RailsApps/rails-prelaunch-signup/master/app/views/devise/confirmations/show.html.haml', 'app/views/devise/confirmations/show.html.haml'
  end
end

# >-------------------------------[ HomePage ]--------------------------------<
after_bundler do
  say_wizard "HomePage recipe running 'after bundler'"
  # remove the default home page
  remove_file 'public/index.html'
  # create a home controller and view
  generate(:controller, "home index")
  # set up a simple home page (with placeholder content)
  if recipes.include? 'haml'
    remove_file 'app/views/home/index.html.haml'
    create_file 'app/views/home/index.html.haml' do 
    <<-'HAML'
%h3 Welcome
HAML
    end
  end
end

# >------------------------------[ Migrations ]-------------------------------<
after_bundler do
  generate 'migration AddOptinToUsers opt_in:boolean'
end

# >-----------------------------[ SeedDatabase ]------------------------------<
after_bundler do
  say_wizard "SeedDatabase recipe running 'after bundler'"
  if recipes.include? 'devise'
    if recipes.include? 'devise-confirmable'
      append_file 'db/seeds.rb' do <<-FILE
puts 'SETTING UP DEFAULT USER LOGIN'
user = User.create! :name => 'First User', :email => 'user@example.com', :password => 'please', :password_confirmation => 'please', :confirmed_at => Time.now.utc
puts 'New user created: ' << user.name
user2 = User.create! :name => 'Second User', :email => 'user2@example.com', :password => 'please', :password_confirmation => 'please', :confirmed_at => Time.now.utc
puts 'New user created: ' << user2.name
FILE
      end
    end
    if recipes.include? 'authorization'
      append_file 'db/seeds.rb' do <<-FILE
user.add_role :admin
FILE
      end
    end
  end
end
after_everything do
  say_wizard "applying migrations and seeding the database"
  if recipes.include? 'devise-invitable'
    run 'bundle exec rake db:migrate'
    generate 'devise_invitable user'
  end
  run 'bundle exec rake db:migrate'
  run 'bundle exec rake db:test:prepare'
  run 'bundle exec rake db:seed'
end

# >-------------------------------[ UsersPage ]-------------------------------<
gem 'google_visualr', '>= 2.1.2'
gem 'jquery-datatables-rails', '>= 1.10.0'
after_bundler do
  say_wizard "UsersPage recipe running 'after bundler'"
  #----------------------------------------------------------------------------
  # Create a users controller
  #----------------------------------------------------------------------------
  generate(:controller, "users show index")
  remove_file 'app/controllers/users_controller.rb'
  get 'https://raw.github.com/RailsApps/rails-prelaunch-signup/master/app/controllers/users_controller.rb', 'app/controllers/users_controller.rb'
  #----------------------------------------------------------------------------
  # Limit access to the users#index page
  #----------------------------------------------------------------------------
  inject_into_file 'app/models/ability.rb', :after => "def initialize(user)\n" do <<-RUBY
    user ||= User.new # guest user (not logged in)
    if user.has_role? :admin
      can :manage, :all
    end
RUBY
  end
  #----------------------------------------------------------------------------
  # Create a users index page
  #----------------------------------------------------------------------------
  remove_file 'app/views/users/index.html.haml'
  get 'https://raw.github.com/RailsApps/rails-prelaunch-signup/master/app/views/users/index.html.haml', 'app/views/users/index.html.haml'
  #----------------------------------------------------------------------------
  # Create a users show page
  #----------------------------------------------------------------------------
  remove_file 'app/views/users/show.html.haml'
  create_file 'app/views/users/show.html.haml' do <<-'HAML'
%p
  User: #{@user.name}
%p
  Email: #{@user.email if @user.email}
HAML
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
end
RUBY
  end
  # modify the home page
  remove_file 'app/views/home/index.html.haml'
  create_file 'app/views/home/index.html.haml' do
      <<-'HAML'
%h3 Welcome
HAML
  end
end

# >---------------------------------[ html5 ]---------------------------------<
gem 'bootstrap-sass', '>= 2.0.4.0'
recipes << 'bootstrap'
after_bundler do
  say_wizard "HTML5 recipe running 'after bundler'"
  # add a humans.txt file
  get 'https://raw.github.com/RailsApps/rails3-application-templates/master/files/humans.txt', 'public/humans.txt'
  # install a front-end framework for HTML5 and CSS3
  remove_file 'app/assets/stylesheets/application.css'
  remove_file 'app/views/layouts/application.html.erb'
  remove_file 'app/views/layouts/application.html.haml'
  # Haml version of a complex application layout using Twitter Bootstrap
  get 'https://raw.github.com/RailsApps/rails3-application-templates/master/files/twitter-bootstrap/views/layouts/application.html.haml', 'app/views/layouts/application.html.haml'
  get 'https://raw.github.com/RailsApps/rails3-application-templates/master/files/twitter-bootstrap/views/layouts/_messages.html.haml', 'app/views/layouts/_messages.html.haml'
  # complex css styles using Twitter Bootstrap
  remove_file 'app/assets/stylesheets/application.css.scss'
  get 'https://raw.github.com/RailsApps/rails-prelaunch-signup/master/app/assets/stylesheets/application.css.scss', 'app/assets/stylesheets/application.css.scss'
  # get an appropriate navigation partial
  get 'https://raw.github.com/RailsApps/rails3-application-templates/master/files/navigation/devise/authorization/_navigation.html.haml', 'app/views/layouts/_navigation.html.haml'
  gsub_file 'app/views/layouts/application.html.haml', /App_Name/, "#{app_name.humanize.titleize}"
  gsub_file 'app/views/layouts/_navigation.html.haml', /App_Name/, "#{app_name.humanize.titleize}"
  create_file 'app/assets/stylesheets/bootstrap_and_overrides.css.scss', <<-RUBY
// Set the correct sprite paths
$iconSpritePath: asset-url('glyphicons-halflings.png', image);
$iconWhiteSpritePath: asset-url('glyphicons-halflings-white.png', image);
@import "bootstrap";
body { padding-top: 60px; }
@import "bootstrap-responsive";
RUBY
end

# >------------------------------[ SimpleForm ]-------------------------------<
gem 'simple_form'
recipes << 'simple_form'
recipes << 'simple_form_bootstrap'
after_bundler do
  say_wizard "Simple form recipe running 'after bundler'"
  generate 'simple_form:install --bootstrap'
end

# >------------------------------[ JavaScript ]-------------------------------<
after_bundler do
  remove_file 'app/assets/javascripts/application.js'
  get 'https://raw.github.com/RailsApps/rails-prelaunch-signup/master/app/assets/javascripts/application.js', 'app/assets/javascripts/application.js'
  remove_file 'app/assets/javascripts/users.js.coffee'
  get 'https://raw.github.com/RailsApps/rails-prelaunch-signup/master/app/assets/javascripts/users.js.coffee', 'app/assets/javascripts/users.js.coffee'
end

# >------------------------------[ MailChimp ]-------------------------------<
# the 'app/models/user.rb' file contains methods to support MailChimp; remove and replace them if we don't want MailChimp
if config['mailchimp']
  gem 'hominid'
else
  after_bundler do
    # drop the MailChimp methods and add a UserMailer
    gsub_file 'app/models/user.rb', /after_create :add_user_to_mailchimp unless Rails.env.test\?/, 'after_create :send_welcome_email'
    gsub_file 'app/models/user.rb', /before_destroy :remove_user_from_mailchimp unless Rails.env.test\?\n/, ''
    inject_into_file 'app/models/user.rb', :after => "private\n" do 
  <<-RUBY
\n
  def send_welcome_email
     unless self.email.include?('@example.com') && Rails.env != 'test'
       UserMailer.welcome_email(self).deliver
     end
   end
RUBY
    end
    generate 'mailer UserMailer'
    remove_file 'spec/mailers/user_mailer_spec.rb'
    get 'https://raw.github.com/RailsApps/rails-prelaunch-signup/master/spec/mailers/user_mailer_spec.rb', 'spec/mailers/user_mailer_spec.rb'
    remove_file 'app/mailers/user_mailer.rb'
    get 'https://raw.github.com/RailsApps/rails-prelaunch-signup/master/app/mailers/user_mailer.rb', 'app/mailers/user_mailer.rb'
    if recipes.include? 'mandrill'
      inject_into_file 'app/mailers/user_mailer.rb', :after => "mail(:to => user.email, :subject => \"Invitation Request Received\")\n" do <<-RUBY
    headers['X-MC-Track'] = "opens, clicks"
    headers['X-MC-GoogleAnalytics'] = "example.com"
    headers['X-MC-Tags'] = "welcome"
RUBY
      end
    end
    remove_file 'app/views/user_mailer/welcome_email.html.erb'
    get 'https://raw.github.com/RailsApps/rails-prelaunch-signup/master/app/views/user_mailer/welcome_email.html.erb', 'app/views/user_mailer/welcome_email.html.erb'
    remove_file 'app/views/user_mailer/welcome_email.text.erb'
    get 'https://raw.github.com/RailsApps/rails-prelaunch-signup/master/app/views/user_mailer/welcome_email.text.erb', 'app/views/user_mailer/welcome_email.text.erb'
  end
end

# >------------------------------[ Devise Email ]-------------------------------<
after_bundler do
  remove_file 'app/views/devise/mailer/confirmation_instructions.html.erb'
  get 'https://raw.github.com/RailsApps/rails-prelaunch-signup/master/app/views/devise/mailer/confirmation_instructions.html.erb', 'app/views/devise/mailer/confirmation_instructions.html.erb'
end

# >------------------------------[ Controllers ]-------------------------------<
after_bundler do
  remove_file 'app/controllers/registrations_controller.rb'
  get 'https://raw.github.com/RailsApps/rails-prelaunch-signup/master/app/controllers/registrations_controller.rb', 'app/controllers/registrations_controller.rb'
  remove_file 'app/controllers/confirmations_controller.rb'
  get 'https://raw.github.com/RailsApps/rails-prelaunch-signup/master/app/controllers/confirmations_controller.rb', 'app/controllers/confirmations_controller.rb'
end

# >------------------------------[ Routes ]-------------------------------<
after_bundler do
  remove_file 'config/routes.rb'
  get 'https://raw.github.com/RailsApps/rails-prelaunch-signup/master/config/routes.rb', 'config/routes.rb'
  gsub_file 'config/routes.rb', /RailsPrelaunchSignup/, app_const_base
end

# >------------------------------[ Messages ]-------------------------------<
after_bundler do
  gsub_file 'config/locales/devise.en.yml', /'A message with a confirmation link has been sent to your email address. Please open the link to activate your account.'/, "'Your invitation request has been received. You will receive an invitation when we launch.'"
  gsub_file 'config/locales/devise.en.yml', /'You have to confirm your account before continuing.'/, "'Your account is not active.'"
end

# >--------------------------------[ Cleanup ]--------------------------------<
after_bundler do
  say_wizard "Cleanup recipe running 'after bundler'"
  # remove unnecessary files
  %w{
    README
    doc/README_FOR_APP
    public/index.html
    app/assets/images/rails.png
  }.each { |file| remove_file file }
  # add placeholder READMEs
  get "https://raw.github.com/RailsApps/rails3-application-templates/master/files/sample_readme.txt", "README"
  get "https://raw.github.com/RailsApps/rails3-application-templates/master/files/sample_readme.textile", "README.textile"
  gsub_file "README", /App_Name/, "#{app_name.humanize.titleize}"
  gsub_file "README.textile", /App_Name/, "#{app_name.humanize.titleize}"
  # remove commented lines and multiple blank lines from Gemfile
  # thanks to https://github.com/perfectline/template-bucket/blob/master/cleanup.rb
  gsub_file 'Gemfile', /#.*\n/, "\n"
  gsub_file 'Gemfile', /\n^\s*\n/, "\n"
  # remove commented lines and multiple blank lines from config/routes.rb
  gsub_file 'config/routes.rb', /  #.*\n/, "\n"
  gsub_file 'config/routes.rb', /\n^\s*\n/, "\n"
end

# >--------------------------------[ Extras ]---------------------------------<
if config['jsruntime']
  say_wizard "Adding 'therubyracer' JavaScript runtime gem"
  # maybe it was already added by the html5 recipe for bootstrap_less?
  unless recipes.include? 'jsruntime'
    gem 'therubyracer', :group => :assets, :platform => :ruby
  end
end

# >----------------------------------[ Git ]----------------------------------<
after_everything do
  say_wizard "Git recipe running 'after everything'"
  # Git should ignore some files
  remove_file '.gitignore'
  get "https://raw.github.com/RailsApps/rails3-application-templates/master/files/gitignore.txt", ".gitignore"
  # Initialize new Git repo
  git :init
  git :add => '.'
  git :commit => "-aqm 'new Rails app generated by Rails Apps Composer gem'"
end

__END__

name: PrelaunchSignup
description: "Generates a Prelaunch Signup App"
author: RailsApps

category: other

config:
  - mailer:
      type: multiple_choice
      prompt: "How will you send email?"
      choices: [["SMTP account", smtp], ["Gmail account", gmail], ["SendGrid account", sendgrid], ["Mandrill by MailChimp account", mandrill]]
  - mailchimp:
      type: boolean
      prompt: Use MailChimp to send news and welcome messages?
  - jsruntime:
      type: boolean
      prompt: Add 'therubyracer' JavaScript runtime (for Linux users without node.js)?
