if recipes.include? 'heroku'
  before_config do
    config['heroku'] = wizard_yes?("Use Heroku addon for Hoptoad?")
  end
end

gem 'hoptoad_notifier'

if config['heroku']
  generate "hoptoad --heroku"
else
  generate "hoptoad --api-key #{config['api_key']}"
end

__END__

name: Hoptoad
description: Add Hoptoad exception reporting to your application.

category: services
exclusive: exception_notification
tags: [exception_notification]

config:
  - api_key:
      prompt: "Enter Hoptoad API Key:"
      type: string
      unless: heroku
