# Application template recipe for the rails_apps_composer. Change the recipe here:
# https://github.com/RailsApps/rails_apps_composer/blob/master/recipes/routes.rb

after_bundler do
  say_wizard "recipe running after 'bundle install'"
  ### REMOVE THE DEFAULT HOME PAGE ###
  remove_file 'public/index.html'
  ### HOME ###
  if recipes.include? 'simple_home'
    gsub_file 'config/routes.rb', /get \"home\/index\"/, 'root :to => "home#index"'
  end
  ## DEVISE
  if (recipes.include? 'devise') && (recipes.include? 'simple_home')
    inject_into_file 'config/routes.rb', :before => "  root :to" do <<-RUBY
  authenticated :user do
    root :to => 'home#index'
  end
\n
RUBY
    end
  end
  ### USER_ACCOUNTS ###
  ## DEVISE
  if (recipes.include? 'devise') && (recipes.include? 'user_accounts')
    # @devise_for :users@ route must be placed above @resources :users, :only => :show@.
    gsub_file 'config/routes.rb', /get \"users\/show\"/, ''
    gsub_file 'config/routes.rb', /get \"users\/index\"/, ''
    gsub_file 'config/routes.rb', /devise_for :users/ do
    <<-RUBY
devise_for :users
  resources :users, :only => [:show, :index]
RUBY
    end
  end  
  ## OMNIAUTH
  if (recipes.include? 'omniauth') && (recipes.include? 'user_accounts')
    route "match '/auth/failure' => 'sessions#failure'"
    route "match '/signout' => 'sessions#destroy', :as => :signout"
    route "match '/signin' => 'sessions#new', :as => :signin"
    route "match '/auth/:provider/callback' => 'sessions#create'"
    route "resources :users, :only => [ :show, :edit, :update ]"
  end
  ### GIT ###
  git :add => '.' if recipes.include? 'git'
  git :commit => "-aqm 'rails_apps_composer: routes'" if recipes.include? 'git'
end # after_bundler

__END__

name: routes
description: "Add routes needed for starter apps."
author: RailsApps

run_after: [controllers]
category: other
tags: [utilities, configuration]