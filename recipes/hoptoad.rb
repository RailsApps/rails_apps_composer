
gem 'hoptoad_notifier'

if config['use_heroku']
  after_everything do
    say_wizard "Adding hoptoad:basic Heroku addon (you can always upgrade later)"
    run "heroku addons:add hoptoad:basic"
    generate "hoptoad --heroku"
  end
else
  after_bundler do
    generate "hoptoad --api-key #{config['api_key']}"
  end
end

__END__

name: Hoptoad
description: Add Hoptoad exception reporting to your application.

category: services
exclusive: exception_notification
tags: [exception_notification]
run_after: [heroku]

config:
  - use_heroku:
      type: boolean
      prompt: "Use the Hoptoad Heroku addon?"
      if_recipe: heroku
  - api_key:
      prompt: "Enter Hoptoad API Key:"
      type: string
      unless: use_heroku
