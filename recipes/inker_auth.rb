prefs[:authentication] = 'inker_auth' if config['inker_auth']

#TODO find a way to specify gem's source at gemfury #source => 'https://w1BjKxCk1WZoaF4QXkiA@gem.fury.io/me/'
add_gem 'mysql2', '~> 0.3.11'
add_gem 'inker_directory_client', :git => 'https://github.com/customink/inker_directory_client'
add_gem 'inker_auth', :git => 'https://github.com/customink/inker_auth'

stage_two do
  run 'bundle exec rails generate inker_auth:install'
  run 'bundle exec rake db:migrate'
  inject_into_file 'app/controllers/application_controller.rb', "\tbefore_filter :inker_required!\n",
                   :after => "class ApplicationController < ActionController::Base\n"
  app_id = ask_wizard("Enter inker_auth app id:")
  api_key = ask_wizard("Enter inker_auth api key:")
  inject_into_file '.env', "INKER_DIR_APP_ID=#{app_id}\n", :before => /^\n/
  inject_into_file '.env', "INKER_DIR_API_KEY=#{api_key}\n", :before => /^\n/
end

__END__

name: inker_auth
description: "Add Inker Auth for authentication"
author: akolas

requires: [setup, gems, dotenv]
run_after: [setup, gems, dotenv]
category: customInk
