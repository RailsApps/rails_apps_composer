# Application template recipe for the rails_apps_composer. Change the recipe here:
# https://github.com/RailsApps/rails_apps_composer/blob/master/recipes/controllers.rb

after_bundler do
  say_wizard "recipe running after 'bundle install'"
  ### APPLICATION_CONTROLLER ###
  if prefer :authentication, 'omniauth'
    copy_from_repo 'app/controllers/application_controller.rb', :repo => 'https://raw.github.com/RailsApps/rails3-mongoid-omniauth/master/'
  end
  if prefer :authorization, 'cancan'
    inject_into_file 'app/controllers/application_controller.rb', :before => "\nend" do <<-RUBY
\n
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
  case prefs[:starter_app]
    when 'users_app'
      if prefer :authentication, 'devise'
        copy_from_repo 'app/controllers/users_controller.rb', :repo => 'https://raw.github.com/RailsApps/rails3-devise-rspec-cucumber/master/'
      elsif prefer :authentication, 'omniauth'
        copy_from_repo 'app/controllers/users_controller.rb', :repo => 'https://raw.github.com/RailsApps/rails3-mongoid-omniauth/master/'
      end
    when 'admin_app'
      if prefer :authentication, 'devise'
        copy_from_repo 'app/controllers/users_controller.rb', :repo => 'https://raw.github.com/RailsApps/rails3-bootstrap-devise-cancan/master/'
      elsif prefer :authentication, 'omniauth'
        copy_from_repo 'app/controllers/users_controller.rb', :repo => 'https://raw.github.com/RailsApps/rails3-mongoid-omniauth/master/'
      end
    when 'subdomains_app'
      copy_from_repo 'app/controllers/users_controller.rb', :repo => 'https://raw.github.com/RailsApps/rails3-subdomains/master/'
  end
  ### SESSIONS_CONTROLLER ###
  if prefer :authentication, 'omniauth'
    filename = 'app/controllers/sessions_controller.rb'
    copy_from_repo filename, :repo => 'https://raw.github.com/RailsApps/rails3-mongoid-omniauth/master/'
    gsub_file filename, /twitter/, prefs[:omniauth_provider] unless prefer :omniauth_provider, 'twitter'
    if prefer :authorization, 'cancan'
      inject_into_file filename, "    user.add_role :admin if User.count == 1 # make the first user an admin\n", :after => "session[:user_id] = user.id\n"
    end
  end
  ### PROFILES_CONTROLLER ###
  copy_from_repo 'app/controllers/profiles_controller.rb', :repo => 'https://raw.github.com/RailsApps/rails3-subdomains/master/' if prefer :starter_app, 'subdomains_app'
  ### GIT ###
  git :add => '-A' if prefer :git, true
  git :commit => '-qm "rails_apps_composer: controllers"' if prefer :git, true
end # after_bundler

__END__

name: controllers
description: "Add controllers needed for starter apps."
author: RailsApps

requires: [setup, gems, models]
run_after: [setup, gems, models]
category: mvc
