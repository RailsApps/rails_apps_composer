# Application template recipe for rails-apps-composer gem to add
# simple-navigation gem support

if config['simple_navigation']
  gem 'simple-navigation', '~> 3.7'
else
  recipes.delete('simple_navigation')
end

after_bundler do

  say_wizard "Simple_navigation recipe running 'after bundler'"

  # Get a basic config files
  if recipes.include? 'devise'
    if recipes.include? 'authorization'
      get 'https://raw.github.com/akiva/rails-application-boilerplates/master/config/navigation-devise-authorization.rb', 'config/navigation.rb'
    else
      get 'https://raw.github.com/akiva/rails-application-boilerplates/master/config/navigation-devise.rb', 'config/navigation.rb'
    end
  elsif recipes.include? 'omniauth'
    get 'https://raw.github.com/akiva/rails-application-boilerplates/master/config/navigation-omniauth.rb', 'config/navigation.rb'
  else
    get 'https://raw.github.com/akiva/rails-application-boilerplates/master/config/navigation-basic.rb', 'config/navigation.rb'
  end

end

__END__

name: simple_navigation
description: "Adds simple-navigation gem support, including boilerplate navigation file, taking into account the possibility of Devise or Omniauth"
author: Akiva Levy

category: other
tags: [utilities, configuration]

config:
  - simple_navigation:
      type: boolean
      prompt: "Would you like to use simple-navigation for your site navigation?"
