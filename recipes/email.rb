# Application template recipe for the rails_apps_composer. Change the recipe here:
# https://github.com/RailsApps/rails_apps_composer/blob/master/recipes/email.rb

after_bundler do
  say_wizard "recipe running after 'bundle install'"
  if recipes.include? 'email'
    ### DEVELOPMENT
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
    ### TEST
    inject_into_file 'config/environments/test.rb', :before => "\nend" do 
  <<-RUBY
\n  
  # ActionMailer Config
  config.action_mailer.default_url_options = { :host => 'example.com' }
RUBY
    end
    ### PRODUCTION
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
  end
  ### GMAIL ACCOUNT
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
    inject_into_file 'config/environments/development.rb', gmail_configuration_text, :after => 'config.action_mailer.default :charset => "utf-8"'
    inject_into_file 'config/environments/production.rb', gmail_configuration_text, :after => 'config.action_mailer.default :charset => "utf-8"'
  end
  ### SENDGRID ACCOUNT
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
    inject_into_file 'config/environments/development.rb', sendgrid_configuration_text, :after => 'config.action_mailer.default :charset => "utf-8"'
    inject_into_file 'config/environments/production.rb', sendgrid_configuration_text, :after => 'config.action_mailer.default :charset => "utf-8"'
  end
    ### MANDRILL ACCOUNT
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
      inject_into_file 'config/environments/development.rb', mandrill_configuration_text, :after => 'config.action_mailer.default :charset => "utf-8"'
      inject_into_file 'config/environments/production.rb', mandrill_configuration_text, :after => 'config.action_mailer.default :charset => "utf-8"'
    end
    ### GIT
    git :add => '.' if recipes.include? 'git'
    git :commit => "-aqm 'rails_apps_composer: set email accounts'" if recipes.include? 'git'
end # after_bundler

__END__

name: email
description: "Configure email accounts."
author: RailsApps

category: other
tags: [utilities, configuration]
