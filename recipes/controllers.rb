# Application template recipe for the rails_apps_composer. Change the recipe here:
# https://github.com/RailsApps/rails_apps_composer/blob/master/recipes/controllers.rb

after_bundler do
  say_wizard "recipe running after 'bundle install'"
  ### APPLICATION_CONTROLLER ###
  if prefer :authentication, 'omniauth'
    copy_from_repo 'app/controllers/application_controller.rb', :repo => 'https://raw.github.com/RailsApps/rails3-mongoid-omniauth/master/'
  end
  if prefer :authorization, 'cancan'
    inject_into_file 'app/controllers/application_controller.rb', :before => 'end' do <<-RUBY
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, :alert => exception.message
  end
RUBY
    end
  end  
  ### HOME_CONTROLLER ###
  if ['home_app','users_app','admin_app','subdomains_app'].include? prefs[:starter_app]
    generate(:controller, "home index")
  end
  if ['users_app','admin_app','subdomains_app'].include? prefs[:starter_app]
    gsub_file 'app/controllers/home_controller.rb', /def index/, "def index\n    @users = User.all"
  end
  ### USERS_CONTROLLER ###
  if ['users_app','admin_app','subdomains_app'].include? prefs[:starter_app]
    if prefer :authentication, 'devise'
      copy_from_repo 'app/controllers/users_controller.rb', :repo => 'https://raw.github.com/RailsApps/rails3-devise-rspec-cucumber/master/'
    elsif prefer :authentication, 'omniauth'
      copy_from_repo 'app/controllers/users_controller.rb', :repo => 'https://raw.github.com/RailsApps/rails3-mongoid-omniauth/master/'
    end
    if prefer :authorization, 'cancan'
      inject_into_file 'app/controllers/users_controller.rb', "    authorize! :index, @user, :message => 'Not authorized as an administrator.'\n", :after => "def index\n"
    end
  end
  gsub_file 'app/controllers/users_controller.rb', /before_filter :authenticate_user!/, '' if prefer :starter_app, 'subdomains_app'
  ### SESSIONS_CONTROLLER ###
  if prefer :authentication, 'omniauth'
    filename = 'app/controllers/sessions_controller.rb'
    copy_from_repo filename, :repo => 'https://raw.github.com/RailsApps/rails3-mongoid-omniauth/master/'
    gsub_file filename, /twitter/, prefs[:omniauth_provider] unless prefer :omniauth_provider, 'twitter'
  end
  ### PROFILES_CONTROLLER ###
  copy_from_repo 'app/controllers/profiles_controller.rb', :repo => 'https://raw.github.com/RailsApps/rails3-subdomains/master/' if prefer :starter_app, 'subdomains_app'
  ### GIT ###
  git :add => '.' if prefer :git, true
  git :commit => "-aqm 'rails_apps_composer: controllers'" if prefer :git, true
end # after_bundler

__END__

name: controllers
description: "Add controllers needed for starter apps."
author: RailsApps

requires: [setup, gems, models]
run_after: [setup, gems, models]
category: mvc
