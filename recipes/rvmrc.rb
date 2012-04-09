after_bundler do
  # say_wizard "rvmrc recipe running 'after bundler'"

  if config['rvmrc']
    say_wizard "creating .rvmrc file in app root"
    ## Create .rvmrc
    ## Gemset defaults as the new Rails application name
    file '.rvmrc', <<-RVMRC
    rvm use --create 1.9.3@#{@app_name}
    RVMRC
    ## Trust the new .rvmrc
    run "rvm rvmrc trust"
    ## Change dir and change back into the app to install gems in that gemset
    run "cd .. && cd #{@app_name}"
    ## Install bundler so bundle install works
    run "gem install bundler"
  end
end
  


__END__

name: rvmrc
description: Create an .rvmrc file in the application directory and trust it.

category: development
exclusive: development_environment

config:
  - rvmrc:
      type: boolean
      prompt: Would you like to add an .rvmrc file to the app directory?
