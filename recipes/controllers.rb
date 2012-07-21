# Application template recipe for the rails_apps_composer. Change the recipe here:
# https://github.com/RailsApps/rails_apps_composer/blob/master/recipes/controllers.rb

after_bundler do
  say_wizard "recipe running after 'bundle install'"
  ### APPLICATION_CONTROLLER ###
  if recipes.include? 'omniauth'
    copy_from_repo 'app/controllers/application_controller.rb', 'https://raw.github.com/RailsApps/rails3-mongoid-omniauth/master/'
  end
  if recipes.include? 'cancan'
    inject_into_file 'app/controllers/application_controller.rb', :before => 'end' do <<-RUBY
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, :alert => exception.message
  end
RUBY
    end
  end  
  ### HOME_CONTROLLER ###
  if recipes.include? 'simple_home'
    generate(:controller, "home index")
  end
  if recipes.include? 'user_accounts'
    gsub_file 'app/controllers/home_controller.rb', /def index/, "def index\n    @users = User.all"
  end
  ### USERS_CONTROLLER ###
  if recipes.include? 'user_accounts'
    if recipes.include? 'devise'
      copy_from_repo 'app/controllers/users_controller.rb', 'https://raw.github.com/RailsApps/rails3-devise-rspec-cucumber/master/'
    elsif recipes.include? 'omniauth'
      copy_from_repo 'app/controllers/users_controller.rb', 'https://raw.github.com/RailsApps/rails3-mongoid-omniauth/master/'
    end
    if recipes.include? 'cancan'
      inject_into_file 'app/controllers/users_controller.rb', "    authorize! :index, @user, :message => 'Not authorized as an administrator.'\n", :after => "def index\n"
    end
    if recipes.include? 'paginate'
      gsub_file 'app/controllers/users_controller.rb', /@users = User.all/, '@users = User.paginate(:page => params[:page])'
    end
  end
  ### SESSIONS_CONTROLLER ###
  if recipes.include? 'omniauth'
    filename = 'app/controllers/sessions_controller.rb'
    copy_from_repo filename, 'https://raw.github.com/RailsApps/rails3-mongoid-omniauth/master/'
    provider = 'facebook' if recipes.include? 'facebook'
    provider = 'github' if recipes.include? 'github'
    provider = 'linkedin' if recipes.include? 'linkedin'
    provider = 'google-oauth2' if recipes.include? 'google-oauth2'
    provider = 'tumblr' if recipes.include? 'tumblr'
    gsub_file filename, /twitter/, provider unless recipes.include? 'twitter'
  end
  ### GIT ###
  git :add => '.' if recipes.include? 'git'
  git :commit => "-aqm 'rails_apps_composer: controllers'" if recipes.include? 'git'
end # after_bundler

__END__

name: controllers
description: "Add controllers needed for starter apps."
author: RailsApps

run_after: [models]
category: other
tags: [utilities, configuration]
