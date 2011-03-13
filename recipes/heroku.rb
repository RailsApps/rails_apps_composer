after_bundler do
  heroku_name = nil
  while heroku_name.blank? || !system("heroku create #{heroku_name}")
    heroku_name = wizard_ask("What do you want to call your app? ")
  end

  git :push => "heroku master"
end

__END__

name: Heroku
description: Create a Heroku application and instantly deploy.
author: mbleigh

exclusive: deployment
category: deployment
tags: [provider]

config:
  - app_name:
      prompt: "Application Name:"
      type: string
  - staging:
      prompt: "Create staging app? (appname-staging.heroku.com)"
      type: boolean
