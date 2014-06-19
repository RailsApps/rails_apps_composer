# Application template recipe for the rails_apps_composer. Change the recipe here:
# https://github.com/RailsApps/rails_apps_composer/blob/master/recipes/pundit.rb

after_bundler do
  say_wizard "recipe running after 'bundle install'"
  if prefer :authorization, 'pundit'
    generate 'migration AddRoleToUsers role:integer'
    if prefer :authentication, 'devise'
      copy_from_repo 'app/models/user.rb', :repo => 'https://raw.github.com/RailsApps/rails-devise-pundit/master/'
      if (prefer :devise_modules, 'confirmable') || (prefer :devise_modules, 'invitable')
        gsub_file 'app/models/user.rb', /:registerable,/, ":registerable, :confirmable,"
        generate 'migration AddConfirmableToUsers confirmation_token:string confirmed_at:datetime confirmation_sent_at:datetime unconfirmed_email:string'
      end
    end
    if prefer :authentication, 'omniauth'
      # TODO
    end
    copy_from_repo 'app/controllers/application_controller.rb', :repo => 'https://raw.github.com/RailsApps/rails-devise-pundit/master/'
  end
  ### GIT ###
  git :add => '-A' if prefer :git, true
  git :commit => '-qm "rails_apps_composer: pundit"' if prefer :git, true
end

__END__

name: pundit
description: "Add Pundit for authorization"
author: RailsApps

requires: [setup, gems, devise]
run_after: [setup, gems, devise]
category: mvc
