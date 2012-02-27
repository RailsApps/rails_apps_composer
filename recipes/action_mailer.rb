# Application template recipe for the rails_apps_composer. Check for a newer version here:
# https://github.com/RailsApps/rails_apps_composer/blob/master/recipes/action_mailer.rb

after_bundler do
  ### modifying environment configuration files for ActionMailer
  say_wizard "ActionMailer recipe running 'after bundler'"
  ### development environment
  gsub_file 'config/environments/development.rb', /# Don't care if the mailer can't send/, '# ActionMailer Config'
  gsub_file 'config/environments/development.rb', /config.action_mailer.raise_delivery_errors = false/ do
  <<-RUBY
config.action_mailer.default_url_options = { :host => 'localhost:3000' }
  config.action_mailer.delivery_method = :smtp
  # change to false to prevent email from being sent during development
  config.action_mailer.perform_deliveries = true
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
  if config['gmail']
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
  
end
  
__END__

name: ActionMailer
description: "Configure ActionMailer to show errors during development and suppress failures when the app is deployed to production."
author: RailsApps

category: other
tags: [utilities, configuration]

config:
  - gmail:
      type: boolean
      prompt: Would you like the app to use a GMail account to send email?
