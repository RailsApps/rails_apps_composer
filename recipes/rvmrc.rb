if config['rvmrc']
  say_wizard "creating .rvmrc file in app root"

  ## Create .rvmrc
  ## Gemset defaults as the new Rails application name
  file '.rvmrc', <<-RVMRC
  rvm use --create 1.9.3@#{@app_name}
  RVMRC

  ## Reload rvm
  run "rvm reload"

  ## Trust .rvmrc file
  # this fails and shows 'RVM is not a function, selecting rubies...'
  # run "rvm rvmrc trust"

  ## Install bundler so bundle install works
  run "gem install bundler"
end
  

__END__

name: rvmrc
description: Create an .rvmrc file in the application directory and trust it.

category: other
tags: [utilities, configuration]

config:
  - rvmrc:
      type: boolean
      prompt: Would you like to add an .rvmrc file to the app directory?
