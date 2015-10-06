add_gem 'rollbar', '~> 2.3.0'

stage_two do
  say_wizard "recipe stage two"
  rollbar_token = ask_wizard("Enter Rollbar post_server_item application token:")
  run "bundle exec rails generate rollbar #{rollbar_token}"
  inject_into_file '.env', "ROLLBAR_ACCESS_TOKEN=#{rollbar_token}\n", :before => /^\n/
  gsub_file 'config/initializers/rollbar.rb', '/^(config.access_token\s?=\s?)(.*$)/', "\0ENV['ROLLBAR_ACCESS_TOKEN']"
end

__END__

name: rollbar
description: "Add Rollbar for exception tracking and logging"
author: eduduc

requires: [setup, gems, dotenv]
run_after: [setup, gems, dotenv]
category: customInk
