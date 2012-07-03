# Application template recipe for the rails_apps_composer. Check for a newer version here:
# https://github.com/RailsApps/rails_apps_composer/blob/master/recipes/unicorn.rb

case config['unicorn']
  when 'development' 
    say_wizard "Adding 'unicorn'"
    gem "unicorn-rails", :platform => :ruby, :group => [:development, :test]
  when 'production' 
    say_wizard "Adding 'unicorn'"
    gem "unicorn-rails", :platform => :ruby, :group => :production
  when 'both' 
    say_wizard "Adding 'unicorn'"
    gem "unicorn-rails", :platform => :ruby
end

__END__

name: Unicorn
description: "Use Unicorn as your default server (works on Heroku with the Celadon Cedar stack)."
author: mmacedo

category: server
tags: [server]

config:
  - unicorn:
      type: multiple_choice
      prompt: Would you like to use unicorn as your server?
      choices: [["No", no], ["In development only", development], ["In production only", production], ["Both development and production", both]]