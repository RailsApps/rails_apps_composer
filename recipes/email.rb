# Application template recipe for the rails_apps_composer. Change the recipe here:
# https://github.com/RailsApps/rails_apps_composer/blob/master/recipes/email.rb

after_bundler do
  say_wizard "recipe running after 'bundle install'"
  unless prefer :email, 'none'
    if rails_4?
      dev_email_text = <<-TEXT
  # ActionMailer Config
  config.action_mailer.default_url_options = { :host => 'localhost:3000' }
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.raise_delivery_errors = true
  # Send email in development mode?
  config.action_mailer.perform_deliveries = true
TEXT
      prod_email_text = <<-TEXT
  # ActionMailer Config
  config.action_mailer.default_url_options = { :host => 'example.com' }
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.perform_deliveries = true
  config.action_mailer.raise_delivery_errors = false
TEXT
      inject_into_file 'config/environments/development.rb', dev_email_text, :after => "config.assets.debug = true"
      inject_into_file 'config/environments/production.rb', prod_email_text, :after => "config.active_support.deprecation = :notify"
      gsub_file 'config/environments/production.rb', /'example.com'/, 'Rails.application.secrets.domain_name' if rails_4_1?

    else
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
  end
  if rails_4_1?
    email_configuration_text = <<-TEXT
\n
  config.action_mailer.smtp_settings = {
    address: "smtp.gmail.com",
    port: 587,
    domain: Rails.application.secrets.domain_name,
    authentication: "plain",
    enable_starttls_auto: true,
    user_name: Rails.application.secrets.email_provider_username,
    password: Rails.application.secrets.email_provider_password
  }
TEXT
    inject_into_file 'config/environments/development.rb', email_configuration_text, :after => "config.assets.debug = true"
    inject_into_file 'config/environments/production.rb', email_configuration_text, :after => "config.active_support.deprecation = :notify"
    case :email
      when 'sendgrid'
        gsub_file 'config/environments/development.rb', /smtp.gmail.com/, 'smtp.sendgrid.net'
        gsub_file 'config/environments/production.rb', /smtp.gmail.com/, 'smtp.sendgrid.net'
      when 'mandrill'
        gsub_file 'config/environments/development.rb', /smtp.gmail.com/, 'smtp.mandrillapp.com'
        gsub_file 'config/environments/production.rb', /smtp.gmail.com/, 'smtp.mandrillapp.com'
        gsub_file 'config/environments/development.rb', /email_provider_password/, 'email_provider_apikey'
        gsub_file 'config/environments/production.rb', /email_provider_password/, 'email_provider_apikey'
    end
  else
    ### GMAIL ACCOUNT
    if prefer :email, 'gmail'
      gmail_configuration_text = <<-TEXT
\n
  config.action_mailer.smtp_settings = {
    address: "smtp.gmail.com",
    port: 587,
    domain: ENV["DOMAIN_NAME"],
    authentication: "plain",
    enable_starttls_auto: true,
    user_name: ENV["GMAIL_USERNAME"],
    password: ENV["GMAIL_PASSWORD"]
  }
TEXT
      inject_into_file 'config/environments/development.rb', gmail_configuration_text, :after => "config.assets.debug = true"
      inject_into_file 'config/environments/production.rb', gmail_configuration_text, :after => "config.active_support.deprecation = :notify"
    end
    ### SENDGRID ACCOUNT
    if prefer :email, 'sendgrid'
      sendgrid_configuration_text = <<-TEXT
\n
  config.action_mailer.smtp_settings = {
    address: "smtp.sendgrid.net",
    port: 587,
    domain: ENV["DOMAIN_NAME"],
    authentication: "plain",
    user_name: ENV["SENDGRID_USERNAME"],
    password: ENV["SENDGRID_PASSWORD"]
  }
TEXT
      inject_into_file 'config/environments/development.rb', sendgrid_configuration_text, :after => "config.assets.debug = true"
      inject_into_file 'config/environments/production.rb', sendgrid_configuration_text, :after => "config.active_support.deprecation = :notify"
    end
    ### MANDRILL ACCOUNT
    if prefer :email, 'mandrill'
      mandrill_configuration_text = <<-TEXT
\n
  config.action_mailer.smtp_settings = {
    :address   => "smtp.mandrillapp.com",
    :port      => 587,
    :user_name => ENV["MANDRILL_USERNAME"],
    :password  => ENV["MANDRILL_APIKEY"]
  }
TEXT
      inject_into_file 'config/environments/development.rb', mandrill_configuration_text, :after => "config.assets.debug = true"
      inject_into_file 'config/environments/production.rb', mandrill_configuration_text, :after => "config.active_support.deprecation = :notify"
    end
  end
  ### GIT
  git :add => '-A' if prefer :git, true
  git :commit => '-qm "rails_apps_composer: set email accounts"' if prefer :git, true
end # after_bundler

__END__

name: email
description: "Configure email accounts."
author: RailsApps

requires: [setup]
run_after: [setup]
category: configuration
