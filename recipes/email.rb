# Application template recipe for the rails_apps_composer. Change the recipe here:
# https://github.com/RailsApps/rails_apps_composer/blob/master/recipes/email.rb

stage_two do
  say_wizard "recipe stage two"
  unless prefer :email, 'none'
    ## ACTIONMAILER CONFIG
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
    gsub_file 'config/environments/production.rb', /'example.com'/, 'Rails.application.secrets.domain_name'
    ## SMTP_SETTINGS
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
    case prefs[:email]
      when 'sendgrid'
        gsub_file 'config/environments/development.rb', /smtp.gmail.com/, 'smtp.sendgrid.net'
        gsub_file 'config/environments/production.rb', /smtp.gmail.com/, 'smtp.sendgrid.net'
      when 'mandrill'
        gsub_file 'config/environments/development.rb', /smtp.gmail.com/, 'smtp.mandrillapp.com'
        gsub_file 'config/environments/production.rb', /smtp.gmail.com/, 'smtp.mandrillapp.com'
        gsub_file 'config/environments/development.rb', /email_provider_password/, 'email_provider_apikey'
        gsub_file 'config/environments/production.rb', /email_provider_password/, 'email_provider_apikey'
    end
  end
  ### GIT
  git :add => '-A' if prefer :git, true
  git :commit => '-qm "rails_apps_composer: set email accounts"' if prefer :git, true
end

__END__

name: email
description: "Configure email accounts."
author: RailsApps

requires: [setup]
run_after: [setup]
category: configuration
