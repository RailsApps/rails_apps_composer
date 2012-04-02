
gem 'airbrake'

if config['use_heroku']
  after_everything do
    say_wizard "Adding airbrake:developer Heroku addon (you can always upgrade later)"
    run "heroku addons:add airbrake:developer"
    generate "airbrake --heroku"
  end
else
  after_bundler do
    generate "airbrake --api-key #{config['api_key']}"
  end
end

__END__

name: Airbrake
description: Add Airbrake exception reporting to your application.

category: services
exclusive: exception_notification
tags: [exception_notification]
run_after: [heroku]

config:
  - use_heroku:
      type: boolean
      prompt: "Use the Airbrake Heroku addon?"
      if_recipe: heroku
  - api_key:
      prompt: "Enter Airbrake API Key:"
      type: string
      unless: use_heroku
