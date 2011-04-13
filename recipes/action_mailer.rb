# Application template recipe for the rails3_devise_wizard. Check for a newer version here:
# https://github.com/fortuity/rails3_devise_wizard/blob/master/recipes/action_mailer.rb

after_bundler do
  
  # modifying environment configuration files for ActionMailer
  gsub_file 'config/environments/development.rb', /# Don't care if the mailer can't send/, '# ActionMailer Config'
  gsub_file 'config/environments/development.rb', /config.action_mailer.raise_delivery_errors = false/ do
  <<-RUBY
config.action_mailer.default_url_options = { :host => 'localhost:3000' }
  # A dummy setup for development - no deliveries, but logged
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.perform_deliveries = false
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.default :charset => "utf-8"
RUBY
  end
  gsub_file 'config/environments/production.rb', /config.active_support.deprecation = :notify/ do
  <<-RUBY
config.active_support.deprecation = :notify

  config.action_mailer.default_url_options = { :host => 'yourhost.com' }
  # ActionMailer Config
  # Setup for production - deliveries, no errors raised
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.perform_deliveries = true
  config.action_mailer.raise_delivery_errors = false
  config.action_mailer.default :charset => "utf-8"
RUBY
  end
  
end
  
__END__

name: ActionMailer
description: "Configure ActionMailer to show errors during development and suppress failures when the app is deployed to production."
author: fortuity

category: other
tags: [utilities, configuration]