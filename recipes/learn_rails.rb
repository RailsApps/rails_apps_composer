# Application template recipe for the rails_apps_composer. Change the recipe here:
# https://github.com/RailsApps/rails_apps_composer/blob/master/recipes/learn_rails.rb

if prefer :apps4, 'learn-rails'

  # preferences
  prefs[:authentication] = false
  prefs[:authorization] = false
  prefs[:dashboard] = 'none'
  prefs[:ban_spiders] = false
  prefs[:better_errors] = true
  prefs[:database] = 'sqlite'
  prefs[:deployment] = 'heroku'
  prefs[:devise_modules] = false
  prefs[:dev_webserver] = 'webrick'
  prefs[:email] = 'sendgrid'
  prefs[:form_builder] = 'simple_form'
  prefs[:frontend] = 'foundation5'
  prefs[:github] = false
  prefs[:git] = true
  prefs[:local_env_file] = 'none'
  prefs[:prod_webserver] = 'same'
  prefs[:pry] = false
  prefs[:secrets] = ['owner_email', 'mailchimp_list_id', 'mailchimp_api_key']
  prefs[:templates] = 'erb'
  prefs[:tests] = false
  prefs[:pages] = 'none'
  prefs[:locale] = 'none'
  prefs[:analytics] = 'none'
  prefs[:rubocop] = false
  prefs[:disable_turbolinks] = false

  # gems
  add_gem 'high_voltage'
  add_gem 'gibbon'
  gsub_file 'Gemfile', /gem 'sqlite3'\n/, ''
  add_gem 'sqlite3', :group => :development
  add_gem 'rails_12factor', :group => :production

  stage_three do
    say_wizard "recipe stage three"
    repo = 'https://raw.github.com/RailsApps/learn-rails/master/'

    # >-------------------------------[ Models ]--------------------------------<

    copy_from_repo 'app/models/contact.rb', :repo => repo
    copy_from_repo 'app/models/visitor.rb', :repo => repo

    # >-------------------------------[ Controllers ]--------------------------------<

    copy_from_repo 'app/controllers/contacts_controller.rb', :repo => repo
    copy_from_repo 'app/controllers/visitors_controller.rb', :repo => repo

    # >-------------------------------[ Mailers ]--------------------------------<

    generate 'mailer UserMailer'
    copy_from_repo 'app/mailers/user_mailer.rb', :repo => repo

    # >-------------------------------[ Views ]--------------------------------<

    copy_from_repo 'app/views/contacts/new.html.erb', :repo => repo
    copy_from_repo 'app/views/pages/about.html.erb', :repo => repo
    copy_from_repo 'app/views/user_mailer/contact_email.html.erb', :repo => repo
    copy_from_repo 'app/views/user_mailer/contact_email.text.erb', :repo => repo
    copy_from_repo 'app/views/visitors/new.html.erb', :repo => repo
    # create navigation links using the rails_layout gem
    generate 'layout:navigation -f'

    # >-------------------------------[ Routes ]--------------------------------<

    copy_from_repo 'config/routes.rb', :repo => repo

    # >-------------------------------[ Assets ]--------------------------------<

    copy_from_repo 'app/assets/javascripts/segmentio.js', :repo => repo

  end
end

__END__

name: learn_rails
description: "learn-rails starter application"
author: RailsApps

requires: [core]
run_after: [git]
category: apps
