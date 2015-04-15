# Application template recipe for the rails_apps_composer. Change the recipe here:
# https://github.com/RailsApps/rails_apps_composer/blob/master/recipes/devise.rb

stage_two do
  say_wizard "recipe stage two"
  if prefer :authentication, 'devise'
    # prevent logging of password_confirmation
    gsub_file 'config/initializers/filter_parameter_logging.rb', /:password/, ':password, :password_confirmation'
    generate 'devise:install'
    generate 'devise_invitable:install' if prefer :devise_modules, 'invitable'
    generate 'devise user' # create the User model
    unless :apps4.to_s.include? 'rails-stripe-'
      generate 'migration AddNameToUsers name:string'
    end
    if (prefer :devise_modules, 'confirmable') || (prefer :devise_modules, 'invitable')
      gsub_file 'app/models/user.rb', /:registerable,/, ":registerable, :confirmable,"
      generate 'migration AddConfirmableToUsers confirmation_token:string confirmed_at:datetime confirmation_sent_at:datetime unconfirmed_email:string'
    end
    run 'bundle exec rake db:migrate'
  end
  ### GIT ###
  git :add => '-A' if prefer :git, true
  git :commit => '-qm "rails_apps_composer: devise"' if prefer :git, true
end

__END__

name: devise
description: "Add Devise for authentication"
author: RailsApps

requires: [setup, gems]
run_after: [setup, gems]
category: mvc
