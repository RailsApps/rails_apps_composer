
gem 'hoptoad_notifier'

after_bundler do
  if config['use_heroku']
    say_wizard "Adding hoptoad:basic Heroku addon (you can always upgrade later)"
    run "heroku addons:add hoptoad:basic"
    generate "hoptoad --heroku"
  else
    generate "hoptoad --api-key #{config['api_key']}"
  end
end

__END__

name: Hoptoad
description: Add Hoptoad exception reporting to your application.

category: services
exclusive: exception_notification
tags: [exception_notification]

config:
  - use_heroku:
      type: boolean
      prompt: "Use the Hoptoad Heroku addon?"

  - api_key:
      prompt: "Enter Hoptoad API Key:"
      type: string
      unless: use_heroku
